import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';

enum Category { furniture, electronics, clothing, books, other } //TODO add more categories

class CategoryField extends StatefulWidget {
  final Function onSubmitted;
  final Category? defaultCategory;
  const CategoryField({super.key, required this.onSubmitted, this.defaultCategory});

  @override
  State<CategoryField> createState() => _CategoryFieldState();
}

class _CategoryFieldState extends State<CategoryField> {
  final List<Category> categoryList = [
    Category.furniture,
    Category.electronics,
    Category.clothing,
    Category.books,
    Category.other
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            color: Color(0xFF979797),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFDFDFDF),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField(
            padding: const EdgeInsets.only(right: 15),
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.category, color: appColor, size: 25),
              hintText: 'Category',
              hintStyle: const TextStyle(
                color: Color(0xFFBEBEBE),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
              border: InputBorder.none,
            ),
            iconEnabledColor: appColor,
            iconDisabledColor: appColor,
            value: widget.defaultCategory,
            items: categoryList.map<DropdownMenuItem<Category>>((Category value) {
              String category = value.toString().split('.').last;
              category = category[0].toUpperCase() + category.substring(1);
              return DropdownMenuItem<Category>(
                value: value,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              widget.onSubmitted(value);
            },
          ),
        )
      ],
    );
  }
}
