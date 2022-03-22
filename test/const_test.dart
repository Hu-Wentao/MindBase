
class Person{
  final String name;
  final int age;

  const Person(this.name, this.age);

}
main(){
  const zs = Person('zs', 18);
  final zs2 = Person('zs', 18);
  final zs3 =const  Person('zs', 18);
  print("${identical(zs, zs2)}");
  print("${identical(zs, zs3)}");
}