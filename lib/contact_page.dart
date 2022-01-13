import 'package:agenda/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  //construtor para carregar os contatos
  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editedContact;
  //indicar se a página foi editada ou não
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact =
          Contact.fromMap(widget.contact!.toMap() as Map<String, dynamic>);

      _nameController.text = _editedContact.name!;
      _emailController.text = _editedContact.email!;
      _phoneController.text = _editedContact.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.name ?? 'Novo Contato'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name != null &&
                  _editedContact.name!.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              }
            },
            child: const Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img!))
                              : const AssetImage("images/person.png")
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover),
                    ),
                  ),
                  onTap: () {
                    //ImagePicker.pickImage(source: ImageSource.gallery)
                    ImagePicker()
                        .getImage(source: ImageSource.camera)
                        .then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.email = text;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: "Phone"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.phone = text;
                    });
                  },
                  keyboardType: TextInputType.phone,
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar Alterações"),
            content: const Text("Se sair as alterações serão perdidadas"),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
