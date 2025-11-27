import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Create a new order and assign a driver automatically
  Future<String> createOrder(Order order) async {
    try {
      // Step 1: Insert the order (without driver yet)
      final insertedOrder = await supabase
          .from('orders')
          .insert(order.toMap())
          .select()
          .maybeSingle();

      if (insertedOrder == null) {
        throw Exception('Failed to create order');
      }

      final orderId = insertedOrder['id'] as String;

      // Step 2: Find an available driver (here using first test driver)
      final driver = await supabase
          .from('users')
          .select('auth_id')
          .eq('role', 'driver')
          .limit(1)
          .maybeSingle();

      String? driverId;
      if (driver != null) {
        driverId = driver['auth_id'] as String;
      }

      if (driverId != null) {
        // Step 3: Update the order with driver assignment
        await supabase.from('orders').update({
          'driver_id': driverId,
          'status': 'accepted',
        }).eq('id', orderId);

        // Step 4: Initialize driver location if missing
        final loc = await supabase
            .from('driver_locations')
            .select()
            .eq('driver_id', driverId)
            .maybeSingle();

        if (loc == null) {
          await supabase.from('driver_locations').insert({
            'driver_id': driverId,
            'lat': 6.5244, // default test location
            'lng': 3.3792,
          });
        }
      }

      return orderId; // Return order id for tracking
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<Order>> fetchUserOrders() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final data = await supabase
          .from('orders')
          .select()
          .eq('user_id', userId);

      return (data as List<dynamic>)
          .map((e) => Order.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
