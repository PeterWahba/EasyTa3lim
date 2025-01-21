import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotifcationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "easyta3lim",
      "private_key_id": "5427b8085fc9322504d6ea726a324207faca8083",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDHgqiiERnG3d4M\n2/A1xE7il6IEtoWTUvSKXAFnssvXquhVPRTNncYRD+ffeZ2AhNhhTIWtzwyqKTY+\n40sWfpKF3vLAZ09KqekhTzvr8HDtsQY4XnUZ0mxzNOsjbDxS/yPj1A4kyWmGEvNs\nBNYJe4x01hHxopuhDBd307R43ZCq+vN4pbYCmcvpzymVfMKQ8tNvU8KQANITEcY7\nEfw5h1oRYWJw0m/I78F782jSMNlltVlggQbkNNyb7l+sJ7WaiHg/lAWm4G+YVK1s\nX6wzvpT9akAs2z8fzzc4R2hHnPy7JpF8YheeGkAn03pgj4ALYumqUNLysay3xQjC\n283zLGILAgMBAAECggEAH1hTVzcZlil4gAu0BzaC8E3DejsU7GsNmYlP/TNVnFox\nK2cv1Ag0PK0DkJRCXxVAC7VikUak5j0YVTQPsYaMTbUT7Y+toPzl8EJLF0wM6gM0\nh3mrqzVorYcEZGnWZnHIeTxxRm1Qg2yJyxBNcmrzS83wPsb97YUBUOW1hoHE/1+r\nxrZNQwTK+qWtygTakHAKjNIou0mMPSjRMw63EFnOBACz9TgA8Av4O2kvBuHzecrK\ntChWWsX40SmTSBBWf5FP6NKbBQS5hWndvR+OzcENBKfGqBvRqMGmZvGTKb8mDacn\n9ZUiT7aCCjFKE+oc/UYoe6m81QwwcuzOcEgA9i9G1QKBgQD2W62tEMWaZeuODVcQ\nU+9kGl0+BewBBqK51rJk+D0GDCo0SEgxPKMuQbnzyHDS6PYUiDDauLy9UV91Ny3/\n5wUEBDXg62dT3o98zaKMkLPOPBakhBFN9A0fo9xL0OSPsav3Gxd6TyUr2ffC/eDI\nL8UZMTJv/+MDP9vnBxkUjYQFhwKBgQDPUZn98oLhL1bSzATpnO550KNJw9fXAq+o\nbyp+R1kDVTf6FcteW9gC46qovRk8lS4+hMXo/NsS8YokwbyFVT0H2f39jtA6BH+O\nzPnqPHliYP0Ayq1uISvd9TW9kRrDalbY91xxmnhfoiwdsN8NzIvB7s0luqdw4+Ve\nUmsW066gXQKBgBONCQZwC06Kghwe4Obx0lC+auHuNGGMdkOLT1MGBEnDk2HczqXh\nqw2Tt78qDBIg3M6aVE43VPstRwcVXvgtDE/aSbBU3jlgs0BzTVAcd7iJOj7KIFlw\nYc4+AdCeflUNA5mzs7RILaoCPVBjN4CLkffC2L7crtZmLfxyqsHfzTdnAoGATyNu\nLhM5xK3mbbc1lNuz6Mos2saoiMncteYhiWzA3NXV9WAGbrGOhqPTjHAKxyaHLZRP\nW/3Rvqx3OErAJQGBt5KOMxEmCU+YRbGXIMQO7e/qBDhZ9bUx4pts9T0Dw16/Yjki\nj7cQhikIwBi5PLI9Ez2OD/3tVtmXv+akPGV3vn0CgYEAw38cMMnlbrKNX/ufzJvJ\nLvr2P/IIo70FOtGlQDCkGyzDpAIj6uVdudY7VZhXDzmUIRGF520QMfMVuBJUEUDM\ni18ibkg+5m6WTEZvMNHBSrc+AQgJJa/o6SfbLTq13iYURTw/3d+f7kzJiJM66g52\ncNQWHZTwvEL6vDYtktunEok=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@easyta3lim.iam.gserviceaccount.com",
      "client_id": "109430704704105958237",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40easyta3lim.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendUserNotifcation({
    required UserNotifcationBody userMessage,
  }) async {
    final String serverAccessTokenKay = await getAccessToken();

    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/easyta3lim/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': userMessage.deviceFcmToken,
        'notification': {
          'title': "Test App",
          'body': userMessage.body,
        },
        'data': {
          'title': userMessage.title,
          'body': userMessage.body,
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $serverAccessTokenKay',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Notification not sent. Status code: ${response.statusCode}');
    }
  }


  static sendTopicNotification({
    required String topic,
    required String title,
    required String body,
  }) async {
    final String serverAccessTokenKay = await getAccessToken();

    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/easyta3lim/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'topic': topic,
        'notification': {
          'title': "Easyta3lim",
          'body': body,
        },
        'data': {
          'title': title,
          'body': body,
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $serverAccessTokenKay',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully to topic: $topic');
    } else {
      print(
          'Notification not sent to topic. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
    }
  }
}

class UserNotifcationBody {
  final String title;
  final String body;
  final String deviceFcmToken;

  UserNotifcationBody({
    required this.title,
    required this.body,
    required this.deviceFcmToken,
  });
}

