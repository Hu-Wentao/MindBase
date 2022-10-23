import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:mind_base/src/core/infra/ui/dialog/dialog.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/space/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

part 'meta_table_list.dart';
part 'table_tile.dart';
part 'table_view_tile.dart';