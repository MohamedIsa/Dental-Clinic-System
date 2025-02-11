import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../functions/treatment/add_treatment.dart';
import '../../functions/treatment/image_handler.dart';
import 'package:go_router/go_router.dart';
import 'widgets/treatment_form_widgets.dart';

class AddTreatmentPage extends StatefulWidget {
  @override
  _AddTreatmentPageState createState() => _AddTreatmentPageState();
}

class _AddTreatmentPageState extends State<AddTreatmentPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _cprController = TextEditingController();
  final TextEditingController _treatmentTypeController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final ImageHandler _imageHandler = ImageHandler();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _timeController.text = DateFormat('HH:mm').format(DateTime.now());
  }

  Future<void> _pickImage() async {
    final file = await _imageHandler.pickImage(context);
    if (file != null) {
      setState(() {
        _imageHandler.selectedFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Treatment Record',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade500,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
            stops: [0.0, 0.8],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.blue.shade50],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TreatmentFormHeader(title: 'Patient Information'),
                      SizedBox(height: 16),
                      TreatmentTextField(
                        controller: _cprController,
                        label: 'CPR',
                        required: true,
                        isCpr: true,
                      ),
                      SizedBox(height: 24),
                      TreatmentFormHeader(title: 'Treatment Details'),
                      SizedBox(height: 16),
                      TreatmentTextField(
                        controller: _treatmentTypeController,
                        label: 'Treatment Type',
                        required: true,
                      ),
                      SizedBox(height: 16),
                      TreatmentTextField(
                        controller: _notesController,
                        label: 'Description',
                        maxLines: 3,
                      ),
                      SizedBox(height: 24),
                      TreatmentAttachmentSection(
                        imageHandler: _imageHandler,
                        onPickImage: _pickImage,
                        onRemoveImage: () {
                          setState(() {
                            _imageHandler.removeImage();
                          });
                        },
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.go('/treatment'),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => handleSave(
                              context,
                              _cprController,
                              _treatmentTypeController,
                              _notesController,
                              _imageHandler,
                              _dateController,
                              _timeController,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade500,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _cprController.dispose();
    _treatmentTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
