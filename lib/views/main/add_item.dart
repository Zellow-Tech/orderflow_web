import 'package:flutter/material.dart';
import 'package:ofg_web/constants/color_palette.dart';
import 'package:ofg_web/widgets/top_label_text_field.dart';

OFGColorPalette _palette = OFGColorPalette();
TopLabelTextField topLabelTextField = TopLabelTextField();

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  
  bool _itemLive = true;
  bool _returnable = false;
  bool _allowCustomOrders = false;

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text("Basic Information"),
            content: Column(
              children: [
                topLabelTextField.topLabelTextField(
                  controller: _nameController,
                  label: "Item Name",
                  hintText: "Enter item name",
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true,
                ),
                const SizedBox(height: 12),
                topLabelTextField.topLabelTextField(
                  controller: _descriptionController,
                  label: "Description",
                  hintText: "Enter item description",
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Step(
            title: Text("Pricing & Quantity"),
            content: Column(
              children: [
                topLabelTextField.topLabelTextField(
                  controller: _priceController,
                  label: "Price",
                  hintText: "Enter item price",
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  requiredField: true,
                ),
                const SizedBox(height: 12),
                topLabelTextField.topLabelTextField(
                  controller: _qtyController,
                  label: "Quantity",
                  hintText: "Enter item quantity",
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  requiredField: true,
                ),
                const SizedBox(height: 12),
                topLabelTextField.topLabelTextField(
                  controller: _discountController,
                  label: "Discount",
                  hintText: "Enter discount percentage",
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  requiredField: false,
                ),
                const SizedBox(height: 12),
                topLabelTextField.topLabelTextField(
                  controller: _taxController,
                  label: "Tax",
                  hintText: "Enter tax percentage",
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  requiredField: false,
                ),
              ],
            ),
          ),
          Step(
            title: Text("Settings"),
            content: Column(
              children: [
                topLabelTextField.topLabelTextField(
                  controller: _unitController,
                  label: "Unit",
                  hintText: "Enter unit of measurement",
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _itemLive,
                      onChanged: (value) {
                        setState(() {
                          _itemLive = value!;
                        });
                      },
                    ),
                    Text("Item Live")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _returnable,
                      onChanged: (value) {
                        setState(() {
                          _returnable = value!;
                        });
                      },
                    ),
                    Text("Returnable")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _allowCustomOrders,
                      onChanged: (value) {
                        setState(() {
                          _allowCustomOrders = value!;
                        });
                      },
                    ),
                    Text("Allow Custom Orders")
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle item submission logic here
                  },
                  child: Text("Add Item"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
