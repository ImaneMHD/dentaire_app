import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AwesomeAlertDialogs {
  ////////**** INFO avec SnackBar ****///////
  static void showCustomInfoDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    AwesomeDialog(
      context: context,
      dialogBackgroundColor: Color(0xffD9D9D9),
      dialogType: DialogType.info,
      borderSide: const BorderSide(
        color: Colors.black,
        width: 2,
      ),
      width: screenWidth * 0.8,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: true,
      onDismissCallback: (type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fermé par $type',
              style: TextStyle(fontSize: 10),
            ),
          ),
        );
      },
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,

      /// Cette propriete desactive l'animation par défaut //
      customHeader: Container(
        child: Icon(
          Icons.info_outline,
          color: Color(0xffD9D9D9),
          size: 100, // Applique la taille personnalisée
        ),
      ),
      //  title: title,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      //  desc: description,
      buttonsTextStyle: const TextStyle(color: Color(0xffb51919), fontSize: 18),
      showCloseIcon: false,
      btnCancelOnPress: onCancelPress,
      btnOkOnPress: onOkPress,
      btnOkColor: Colors.amber,
      btnCancelColor: onCancelPress != null ? Colors.pink : null,
    ).show();
  }

  ////////**** Question ****///////

  static void showCustomQuestionDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      title: title,
      desc: description,
      btnOkOnPress: onOkPress,
      btnOkColor: Colors.black,
      btnCancel: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xffD9D9D9), // Couleur de fond souhaitée
        ),
        child: Icon(
          Icons.abc,
          color: Color(0xff1A6175),
        ), // Remplacez par l'icône souhaitée

        onPressed: () {},
      ),
      btnCancelOnPress: onCancelPress,
    ).show();
  }

  static void showCustomWarningDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      //closeIcon: const Icon(Icons.close_fullscreen_outlined),
      title: title,
      desc: description,
      buttonsTextStyle: const TextStyle(color: Color(0xffb51919), fontSize: 18),
      showCloseIcon: true,
      btnCancelOnPress: onCancelPress,
      btnOkOnPress: onOkPress,
    ).show();
  }

  ////////**** Dialog sans l'entête ****///////
  static void showCustomDialogWithPassingDataBack({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      animType: AnimType.rightSlide,
      title: title,
      titleTextStyle: const TextStyle(
        fontSize: 32,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
      ),
      desc: description,
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
      autoDismiss: false,
      onDismissCallback: (type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dismissed by $type'),
          ),
        );
        Navigator.of(context).pop(type);
      },
      barrierColor: Colors.purple[900]?.withOpacity(0.54),
    ).show();
  }

  ////////**** Info INVERSE ****///////
  static void showCustomInfoInverseDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.infoReverse,
            headerAnimationLoop: true,
            animType: AnimType.bottomSlide,
            title: title,
            reverseBtnOrder: true,
            btnOkOnPress: () {},
            btnCancelOnPress: () {},
            desc: description)
        .show();
  }

  ////////**** Erreur ****///////
  static void showCustomErrorDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: title,
      desc: description,
      btnOkOnPress: () {},
      // btnOkIcon: Icons.cancel,
      // btnOkColor: Color(0xff002c51),
      btnOk: ElevatedButton.icon(
        icon: Icon(Icons.cancel, size: 24), // Taille de l'icône
        label: Text(
          'OK',
          style: TextStyle(fontSize: 18), // Taille du texte
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff002c51), // Couleur de fond du bouton
          foregroundColor: Colors.white, // Couleur du texte et de l'icône
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rayon des coins du bouton
          ),
        ),
        onPressed: () {
          // Action à effectuer lors de l'appui sur le bouton
        },
      ),
    ).show();
  }

  /// ////////**** Boite de dialogue qui se ferme automatiquement  ****///////
  static void showCustomAutoHideDialog({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      title: title,
      desc: description,
      autoHide: const Duration(seconds: 4),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  /// ////////**** Dialogue avec des inputs  ****///////
  static void showCustomDialogWithInput({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Form Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: title,
                  //  prefixIcon: Icon(Icons.text_fields),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: description,
                  prefixIcon: const Icon(Icons.text_fields),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              isFixedHeight: false,
              text: 'Close',
              pressEvent: () {
                dialog.dismiss();
              },
            )
          ],
        ),
      ),
    )..show();
  }

  /// ////////**** Success Dialogue ****///////
  static void showCustomSuccessDialg({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPress,
    VoidCallback? onCancelPress,
  }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: title,
      desc: description,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }
}
