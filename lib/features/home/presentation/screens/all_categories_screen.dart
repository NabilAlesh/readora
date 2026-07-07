// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/core/constant/app_color.dart';
// import 'package:flutter_application_1/models/book_model.dart';
// import 'package:flutter_application_1/widgets/home/category_card.dart';

// class AllCategoriesScreen extends StatelessWidget {
//   final List<CategoryModel> categories; 
//   final List<BookModel>
//   allBooks; 

//   const AllCategoriesScreen({
//     Key? key,
//     required this.categories,
//     required this.allBooks,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'كل التصنيفات',
//           style: TextStyle(
//             color: AppColors.primary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: categories.isEmpty
//           ? const Center(
//               child: Text(
//                 'لا توجد تصنيفات متوفرة حالياً.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: categories.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount:
//                       3, 
//                   crossAxisSpacing: 12, 
//                   mainAxisSpacing: 16, 
//                   childAspectRatio: 0.85, 
//                 ),
//                 itemBuilder: (context, index) {
//                   return CategoryCard(
//                     category: categories[index],
//                     allBooks:
//                         allBooks, 
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
