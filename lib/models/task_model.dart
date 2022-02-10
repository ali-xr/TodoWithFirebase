class TaskModel {
  String? id;
  String title;
  String description;
  List<dynamic> completedDates;
  TaskModel(this.title, this.description, this.completedDates, {this.id});

  static TaskModel fromJson(id, json) {
    return TaskModel(
      json["title"],
      json["description"],
      json["completed_dates"]
          .map((date) => DateTime.parse(
                date.toDate().toString(),
              ))
          .toList(),
      id: id,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "completed_dates": completedDates,
  };
}
