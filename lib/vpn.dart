import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openvpn_flutter/openvpn_flutter.dart';

class MyVpn extends StatefulWidget {
  @override
  _MyVpnState createState() => _MyVpnState();
}

class _MyVpnState extends State<MyVpn> {
  String responseText = '';
  late OpenVPN openVPN;

  Future<void> initVpn() async {
    openVPN = OpenVPN(
      onVpnStatusChanged: (data) {
        print('VPN Status: $data');
      },
      onVpnStageChanged: (data, raw) {
        print('VPN Stage: $data');
      },
    );

    openVPN.initialize(
      groupIdentifier: 'group.com.example.vpn',
      providerBundleIdentifier: 'com.example.VPNExtension',
      localizedDescription: 'VPN Example',
      lastStage: (stage) {
        print('VPN Last Stage: $stage');
      },
      lastStatus: (status) {
        print('VPN Last Status: $status');
      },
    );

    // Replace 'YOUR_OPENVPN_CONFIG_HERE' with your actual OpenVPN configuration
    openVPN.connect('202.59.15.34', 'pakitex',
        username: 'ABAPNANO', password: 'abap@123456');
  }

  Future<void> makeRequest() async {
    // Replace 'https://example.com/api' with your actual API endpoint
    final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

    try {
      // Make the HTTP request
      final http.Response response = await http.get(Uri.parse(apiUrl));

      print("Status code is ${response.statusCode}");

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response body (assuming it's JSON for this example)
        final dynamic data = json.decode(response.body);

        setState(() {
          // Update the UI with the response data
          responseText = 'Response: $data';
        });
      } else {
        // Handle unsuccessful request
        setState(() {
          responseText = 'Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      // Handle network errors or other exceptions
      setState(() {
        responseText = 'Error: $error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initVpn();
  }

  @override
  void dispose() {
    openVPN.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPN & HTTP Request Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              responseText,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: makeRequest,
              child: Text('Make Request'),
            ),
          ],
        ),
      ),
    );
  }
}
