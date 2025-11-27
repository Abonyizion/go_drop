import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/general_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';
import '../../bloc/order_bloc.dart';
import '../../bloc/order_event.dart';
import '../../bloc/order_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textField.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';



class OrderCreationScreen extends StatefulWidget {
  const OrderCreationScreen({super.key});

  @override
  State<OrderCreationScreen> createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends State<OrderCreationScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailController = TextEditingController();


  late OrderBloc orderBloc;

  @override
  void initState() {
    super.initState();
    orderBloc = OrderBloc(repository: OrderRepository());
  }

  void submitOrder() {
    final pickup = pickupController.text.trim();
    final dropoff = dropoffController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;

    if (pickup.isEmpty || dropoff.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pickup and Dropoff are required.")),
      );
      return;
    }

    final order = Order(
      id: '',
      userId: Supabase.instance.client.auth.currentUser!.id,
      pickupAddress: pickup,
      dropoffAddress: dropoff,
      price: price,
      status: 'pending',
    );

    orderBloc.add(CreateOrderEvent(order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => orderBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Order",
            style: TextStyle(
              color: AppColors.buttonBg,
              fontSize: 30,
              height: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: InkWell(
                onTap: () =>  context.push(AppRouter.settings),
                child: Icon(Icons.logout,
                color: AppColors.red,),
              ),
            )
          ],
        ),
        body: Padding(
          padding: GeneralConstants.scaffoldPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.h),
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.location_on_outlined,
                  size: 55,),
                ),
                SizedBox(height: 35.h),
                CustomTextField(
                  icon: Icons.drive_eta,
                  hint: "Pickup Address",
                  obscure: false,
                  controller: pickupController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.offline_bolt,
                  hint: "Dropoff Address",
                  obscure: false,
                  controller: dropoffController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.monetization_on_outlined,
                  hint: "Price",
                  obscure: false,
                  controller: priceController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.details,
                  hint: "Item Details",
                  obscure: false,
                  controller: detailController,
                ),
                const SizedBox(
                    height: 35),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Text("Estimated Delivery Fee: 7.50",
                  style: TextStyle(
                      fontSize: 14,
                  color: AppColors.buttonBg,
                  fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                BlocConsumer<OrderBloc, OrderState>(
                  listener: (context, state) {
                    if (state is OrderSuccess) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Order Created'),
                          content: const Text('Your order has been placed successfully!'),
                          actions: [
                            TextButton(
                            onPressed: () {
                              context.pop();
                              context.pushNamed(
                                AppRouter.orderTracking,
                                pathParameters: {'orderId': state.orderId!}, // pass the ID
                              );
                            },
                            child: const Text('Track Order'),
                          ),
                          ],
                        ),
                      );
                      pickupController.clear();
                      dropoffController.clear();
                      priceController.clear();
                      detailController.clear();
                    } else if (state is OrderFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: state is OrderLoading ? "" : "Create Order & Proceed to Map",
                      loading: state is OrderLoading,
                      onTap: submitOrder,
                      textColor: AppColors.white,
                      bgColor: AppColors.buttonBg,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
