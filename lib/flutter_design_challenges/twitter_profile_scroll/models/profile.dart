class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.location,
    required this.slogan,
    required this.description,
    required this.profile_pic,
    required this.banner_pic,
    required this.tags,
  });

  String id;
  String name;
  String location;
  String slogan;
  String description;
  String profile_pic;
  String banner_pic;
  List<String> tags;
}
