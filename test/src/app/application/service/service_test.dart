import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/app/application/service.dart';

main() {
  group("realtime_srv", () {
    test('DataEvtTp', () {
      final events = [
        'databases.default.collections.629393c8ebbbf5094df3e564.documents.633d8542e7d6eab04d04adcb.delete',
        'databases.*.collections.*.documents.*.delete',
        'databases.default.collections.*.documents.633d8542e7d6eab04d04adcb.delete',
        'databases.*.collections.*.documents.633d8542e7d6eab04d04adcb.delete',
        'databases.*.collections.629393c8ebbbf5094df3e564.documents.633d8542e7d6eab04d04adcb.delete',
        'databases.default.collections.629393c8ebbbf5094df3e564.documents.*.delete',
        'databases.*.collections.629393c8ebbbf5094df3e564.documents.*.delete',
        'databases.default.collections.*.documents.*.delete',
        'databases.default.collections.629393c8ebbbf5094df3e564.documents.633d8542e7d6eab04d04adcb',
        'databases.*.collections.*.documents.*',
        'databases.default.collections.*.documents.633d8542e7d6eab04d04adcb',
        'databases.*.collections.*.documents.633d8542e7d6eab04d04adcb',
        'databases.*.collections.629393c8ebbbf5094df3e564.documents.633d8542e7d6eab04d04adcb',
        'databases.default.collections.629393c8ebbbf5094df3e564.documents.*',
        'databases.*.collections.629393c8ebbbf5094df3e564.documents.*',
        'databases.default.collections.*.documents.*',
        'databases.default.collections.629393c8ebbbf5094df3e564',
        'databases.*.collections.*',
        'databases.default.collections.*',
        'databases.*.collections.629393c8ebbbf5094df3e564',
        'databases.default',
        'databases.*'
      ];

      final evt = DataEvtTp.ofEvents(events);
      expect(evt, DataEvtTp.delete);
    });
  });
}
