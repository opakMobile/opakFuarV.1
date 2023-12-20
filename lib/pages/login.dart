import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/pages/LoadingSpinner.dart';
import 'package:opak_fuar/pages/homePage.dart';
import 'package:opak_fuar/pages/settingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title, this.sifre = ''}) : super(key: key);

  final String title;
  final String sifre;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class iskontoFiyat {
  double? fiyat;
  double? isk;
  iskontoFiyat(this.fiyat, this.isk);
}

class _LoginPageState extends State<LoginPage> {
    SharedPreferences? _prefs;


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  

  bool _beniHatirla = false;
  bool dis_kullanim = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool sirketKayitliMi = true;

  @override
  void initState() {
    super.initState();
    _getSavedPassword();
    /*
    KullaniciModel.getUser().then((value) {
      if (value == null) {
        // showAlertDialog2(context, "İlk Girişte Kullanıcı Kaydı zorunludur.");
      } else {
        Ctanim.kullanici = value;
        _userNameController.text = Ctanim.kullanici!.KOD!;
      }
    });
    */
    // ctanim şirketi doldurur
  }



  Future<void> hataGoster(
      {String? mesaj, bool? mesajVarMi, bool ikinciGeriOlsunMu = true}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          align: TextAlign.left,
          title: "Hata",
          message: mesajVarMi == true
              ? "Kullanıcı Parametrelerini Kontrol Ediniz.\n" + mesaj.toString()
              : "Kullanıcı Parametrelerini Kontrol Ediniz",
          onPres: () {
            Navigator.pop(context);
            if (ikinciGeriOlsunMu == true) {
              Navigator.pop(context);
            }
          },
          buttonText: 'Geri',
        );
      },
    );
  }

/*
  Future<bool?> KDVDahilMiCek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? KDV = prefs.getBool('KDV');

    return KDV;
  }

  Future<void> KDVDahilMiKaydet(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('KDV', value);
  }
*/
  bool paremetreHatasiVarMi = false;
  Future<void> click() async {
    _formKey.currentState!.save();


    if (_userNameController.text == "" || _passwordController.text == "") {
      hataGoster(mesajVarMi: false);
      return;
    }else{
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()
          ));

    }
   
  }




  Future<void> _getSavedPassword() async {
    _prefs = await SharedPreferences.getInstance();
    final password = _prefs!.getString("sifre");
    if (password != null) {
      setState(() {
        _passwordController.text = password;
        _beniHatirla = true;
      });
    }
  }

  Future<void> _savePassword() async {
    if (_beniHatirla) {
      await _prefs!.setString("sifre", _passwordController.text);
    } else {
      await _prefs!.remove("sifre");
    }
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    double ekranYuksekligi = ekranBilgisi.size.height;
    double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => settings_page()),
          );
          },
          backgroundColor: Color.fromRGBO(181, 182, 184, 1),
          mini: true,
          child: const Icon(Icons.settings, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/sj.jpg"), fit: BoxFit.cover)),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: ekranYuksekligi / 2.2,
                          width: ekranGenisligi / 2,
                          child: Image.asset('assets/opaklogo2.png')),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Container(
                          height: ekranYuksekligi / 2.1,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.5), // Şeffaf arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                          ),
                          margin:
                              EdgeInsets.only(bottom: 0.0), // Kenar yuvarlatma

                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                          0.9), // Color.fromRGBO(181, 182, 184, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _userNameController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            //controller: _passwordController,
                                            // obscureText: !_isPasswordVisible,
                                            //focusNode: _passwordFocusNode,
                                            cursorColor:
                                                Color.fromARGB(255, 60, 59, 59),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value == "") {
                                                return "Bu Alan Boş Bırakılamaz";
                                              }
                                            },
                                            onSaved: (value) {},
                                            decoration: InputDecoration(
                                              labelText: "Kullanıcı Kodu",
                                              labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 60, 59, 59),
                                                fontSize: 15,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                          0.9), // Color.fromRGBO(181, 182, 184, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.lock,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            controller: _passwordController,
                                            obscureText: !_isPasswordVisible,
                                            //focusNode: _passwordFocusNode,
                                            cursorColor:
                                                Color.fromARGB(255, 60, 59, 59),
                                            onChanged: (value) {
                                              final currentPosition =
                                                  _passwordController.selection;
                                              _passwordController.text = value;
                                              _passwordController.selection =
                                                  currentPosition;
                                            },
                                            validator: (value) {
                                              if (value == "") {
                                                return "Bu Alan Boş Bırakılamaz";
                                              }
                                            },
                                            onSaved: (value) {},
                                            decoration: InputDecoration(
                                              labelText: "Parola",
                                              labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 60, 59, 59),
                                                fontSize: 15,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                          child: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      /*
                                      SizedBox(
                                        width: ekranGenisligi * .5,
                                        child: CheckboxListTile(
                                          activeColor:
                                              Color.fromRGBO(81, 82, 83, 1),

                                          title: const Text(
                                              "Dışarıda Kullanılacak",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                          //style: TextStyle(
                                          // color: Colors.white,)
                                          side: BorderSide(color: Colors.black),
                                          value: dis_kullanim,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (bool? veri) {
                                            print(
                                                "Dışarıdan kullanılabilir : $veri");
                                            setState(() {
                                              dis_kullanim = veri!;
                                            });
                                          },
                                        ),
                                      ),
                                      */
                                      SizedBox(
                                        width: ekranGenisligi * .5,
                                        child: CheckboxListTile(
                                          activeColor:
                                              Color.fromRGBO(81, 82, 83, 1),
                                          side: BorderSide(color: Colors.black),
                                          //child: Text(,
                                          title: Text("Şifremi Hatırla",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                          value: _beniHatirla,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _beniHatirla = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(ekranYuksekligi / 80),
                                  child: SizedBox(
                                    width: ekranGenisligi / 1.5,
                                    height: ekranYuksekligi / 12,
                                    child: ElevatedButton(
                                        child: Text(
                                          "Giriş Yap",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Color.fromRGBO(
                                                192, 192, 192, 1),
                                            shadowColor: Colors.black,
                                            elevation: 20,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            )),
                                        onPressed: () {
                                          if (_formKey.currentState != null &&
                                              _formKey.currentState!
                                                  .validate()) {
                                            click();
                                          }
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                   
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showAlertDialogLogin(BuildContext context, String mesaj) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hatalı İşlem!"),
    content: Text(mesaj),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



showAlertDialogLogin2(BuildContext context, String mesaj) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hatalı İşlem!"),
    content: Text(mesaj),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
