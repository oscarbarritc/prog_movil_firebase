class ProductDao {
  String? cveprod;
  String? descprod;
  String? imgprod;

  ProductDao({
    this.cveprod,
    this.descprod,
    this.imgprod
  });

  Map<String, dynamic> toMap(){
    return{
      'cveprod' : cveprod,
      'descprod' : descprod,
      'imgprod' : imgprod,
    };
  }

}
