import 'package:chicken_sales_control/src/models/gsheet/sale_fields.dart';
import 'package:gsheets/gsheets.dart';

class SalesSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-332502",
  "private_key_id": "a250b4fa3976d7f2b981fb345c5648b032bfbca5",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCnoZxBV4MLacLj\npsm+AR9sTaq35u6IHHykOO4Z/BqdZOC20KgKLJP2+FxfPginuA5oBGeXec6OXkOd\nLcq1YOSOAQ2hIC3p3LbgVyK/FbkTS652KS9YCFMoHj0EVw7TAozNiZZ2QHtDdhPA\nQSQVllPXMQH13mA5NtPT1W5Ima0D3nb8E1K7g34IysK/+qAT+IwaHW4arWj3gVPq\nP1f6BxW4QfmYeuWwrMjc7kei7y9YQlTtCBmFgS7actLOQ3OjjLSJxU64qu8le1Ep\n2m0k/o5AkBo4ghyjsOyYqAGqG8d8hdOaAksDv9cM9yYSy5ZezqtEVlGZ6zkJdL77\np2GB9ui9AgMBAAECggEALFAT+s/z89Xq73wdM42fbWVgnkm9P5zsNAtaoeLbdEUB\nBELHUR00piJEZOcEqbWFlWioq8nG2SrBC/FZdzYcZQ+RN0lG6d3vOAHAzSukZ53n\nihPcEJTuypmnvph28j/n0cOv0yW7j/tMQFPYAp7hHe82GfVFkYpVV9fBVg7Nxkog\nusOBlu14vrbJmt7Ag9qM16UjyelfQOIIG6NcEwWjxB5FTt4yF5+Fd/hSuq/FXROm\nm5BO1c2BGneZD/Nx7bw7IyBgA2Ekmb/SzsOXrJPwJgGKQKpnuExP3vLvBzNr/4T0\nm9nuH8vOLK3Y+GeAUDi59MggbuHUyygXJUO+ePfs3wKBgQDP5JslJihajg/0IVtm\nhsAKVSdSfKn2Po8tRDLD3HroFuz0Qg7Ddt8d4AhepiIzdLguTbPCVOtfO9swMxm3\nMrcqfe811BmfSbfBywnbN1pI3j+8/bXOiKHpS+zCwGTFG81k9ms7tclKLNjO6A4G\n/AfSg8YzdatwFuUg1l5aVofh+wKBgQDOa+/0CUsnrFtji3z5VnE7ZGU+sGphb+/l\nzF2iI+urNs5PQZv5Wx+RF3wL49uH6mkfQMROO8JA5gj1LYyFQRhvfpertgLZd/hd\nLCOpIfbr53jPzj7iw6k4fgHms3o+itHzI0DaPsfv+8IUX01Erbs1Fa0GefrivZLA\n28AWl+0apwKBgQDHDV43Xae5vNgtqlq3ekIaIpp58n9SFWhFsUziGBNeccUDwtQb\n949+LWoWJgANQK6xNxjs8x5Cmy8toV/39wlGGDqYUbMOvyjA10Virkc2CgcBT/Nq\nA4zzsgzKFCjoScyJ5R+bll1bNkGJKstziJF80UtPLlWuB13v6RGCceO9TQKBgEHA\nyDKoMzR0Brhy2mBiVLdih42sjHZ1Pampq7nWT1++mYFNmO2ZRTjmjjELaAaneMzn\nyKBTENGzdO8Ej1pzHeGGJbIgzE+Rk5+6S7G4i/shRK6NOCLryJ+iI+DlEu+RMMeO\nVz4t+WpMe8oZgXd7D8MdIHyLpotLb8/XMB0CUBjJAoGAFrfxQnJk3u5FYKK2xF0I\neDb4SbSzg1HKuB4Xj/mG5pW4sUd+jgHpeg2r+n1H/cEQZ6E66uM0a9Zo0Vw0KuE4\nyopd2hM5NQ8tVfTxo9LwrgVrg8N6d1CRukOfcm2wFqie3Ra1Qe4BZEcANpidt33j\nGYlbeAjCfsvD1r9H4tu4xr0=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-332502.iam.gserviceaccount.com",
  "client_id": "104828661556694186682",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-332502.iam.gserviceaccount.com"
}
  ''';

  static final _spreadsheetId = '1_9w7xm6i7NG5ZXiPqDuWQ_m8POm82Vbpwq-hefWiXdY';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _customerSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _customerSheet = await _getWorkSheet(spreadsheet, title: 'Cliente 1');

      final firstRow = SaleFields.getFields();
      _customerSheet!.values.insertRow(1, firstRow);
    } on Exception catch (e) {
      print('Error al iniciar GSheet: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } on Exception catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}
