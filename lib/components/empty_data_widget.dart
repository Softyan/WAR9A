import 'package:flutter/material.dart';

import '../res/export_res.dart';

class EmptyDataWidget extends StatelessWidget {
  final void Function()? onClick;
  const EmptyDataWidget({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Tidak ada data',
            style: War9aTextstyle.normal,
          ),
          TextButton(onPressed: onClick, child: const Text("Refresh"))
        ],
      ),
    );
  }
}
