class PetValidator {

  String validateImages(List images){
    if(images.isEmpty) return "Adicione imagens do pet";
    return null;
  }

  String validateName(String text){
    if(text.isEmpty) return "Preencha o nome do pet";
    return null;
  }

  String validateDescription(String text){
    if(text.isEmpty) return "Preencha a descrição do pet";
    return null;
  }

  String validateHistory(String text){
    if(text.isEmpty) return "Preencha a história do pet";
    return null;
  }


}