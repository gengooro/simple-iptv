class TmdbVideos {
  List<Results>? results;

  TmdbVideos({this.results});

  TmdbVideos.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? name;
  String? key;
  String? site;
  String? type;
  bool? official;

  Results({this.name, this.key, this.site, this.type, this.official});

  Results.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    site = json['site'];
    type = json['type'];
    official = json['official'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['key'] = key;
    data['site'] = site;
    data['type'] = type;
    data['official'] = official;
    return data;
  }
}
