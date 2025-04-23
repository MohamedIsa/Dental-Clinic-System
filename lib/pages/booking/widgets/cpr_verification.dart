import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/popups.dart';

class CPRVerification extends StatefulWidget {
  final Function(String patientId, String patientName) onPatientVerified;

  const CPRVerification({
    super.key,
    required this.onPatientVerified,
  });

  @override
  State<CPRVerification> createState() => _CPRVerificationState();
}

class _CPRVerificationState extends State<CPRVerification> {
  final TextEditingController _cprController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifyPatient() async {
    if (_cprController.text.length != 9) {
      showErrorDialog(context, 'CPR must be exactly 9 digits');
      return;
    }

    setState(() => isLoading = true);

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('cpr', isEqualTo: _cprController.text)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        if (!mounted) return;
        showErrorDialog(context, 'No patient found with this CPR');
        return;
      }

      final patientDoc = result.docs.first;
      final patientData = patientDoc.data() as Map<String, dynamic>;

      widget.onPatientVerified(
        patientDoc.id,
        patientData['name'] ?? 'Unknown Patient',
      );
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'Error verifying patient: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _cprController,
            keyboardType: TextInputType.number,
            maxLength: 9,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: InputDecoration(
              labelText: 'Patient CPR',
              hintText: 'Enter 9-digit CPR',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading ? null : _verifyPatient,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Verify Patient'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cprController.dispose();
    super.dispose();
  }
}
