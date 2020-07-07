import 'dart:async';

class LoginValidators {

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if(email.contains("@")){
        sink.add(email);
      } else {
        sink.addError("Insira um email válido");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink){
      if(pass.length > 0){
        sink.add(pass);
      } else {
        sink.addError("Insira uma senha");
      }
    }
  );

}