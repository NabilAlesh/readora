class GeneralValidator {
  static String? validate(String? value,{bool ?isValidate}) {
    value = value?.trim();
if(isValidate!=null&&!isValidate){
return 'Input error';
}else
    if (value == null || value.isEmpty) {
      return 'field_required';
    } 
    return null;
  }
}
