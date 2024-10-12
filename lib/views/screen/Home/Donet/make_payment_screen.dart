import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakePaymentScreen extends StatefulWidget {
  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardCVV = TextEditingController();
  TextEditingController cardDate = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Payment method selection
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Visa
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'visa';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPaymentMethod == 'visa'
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(AppImages.visaImage,),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // MasterCard
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'mastercard';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPaymentMethod == 'mastercard'
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(AppImages.masterCardImage),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // PayPal
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'paypal';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedPaymentMethod == 'paypal' ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(AppImages.poyPalImage),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Card holder name
              CustomTextField(
                controller: cardHolderName,
                prifixicon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.person_outline),
                ),
                hintText: 'Card holder name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Card number
              CustomTextField(
                controller: cardNumber,
                prifixicon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.credit_card),
                ),
                hintText: 'Card number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Card cvv/cvc
              CustomTextField(
                controller: cardCVV,
                prifixicon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.lock_outline),
                ),
                hintText: 'CVV/CVC',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV/CVC';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Expiry date
              CustomTextField(
                controller: cardDate,
                prifixicon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.calendar_today_outlined),
                ),
                hintText: 'MM/YY',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiration date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              CustomButton(onTap: (){
                if (_formKey.currentState!.validate()) {
                  print('Payment Processed');
                  print('Payment Method - ${_selectedPaymentMethod}');
                  Get.toNamed(AppRoutes.paymentSuccessScreen);
                }
              }, text: 'Payment Now',
                  color: AppColors.buttonColor,
                  borderColor: AppColors.buttonColor,textColor: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
