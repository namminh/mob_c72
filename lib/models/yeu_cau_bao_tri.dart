class yeucaubaotri_model {
  String displayName;
  // bool employeeId;
  List<int> equipmentId;
  int id;
  List<int> maintenanceTeamId;
  String requestDate;
  List<int> stageId;
  List<int> userId;

  yeucaubaotri_model(
      {this.displayName,
      // this.employeeId,
      this.equipmentId,
      this.id,
      this.maintenanceTeamId,
      this.requestDate,
      this.stageId,
      this.userId});

  yeucaubaotri_model.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    // employeeId = json['employee_id'];
    json['user_id'] is List ? json['user_id'].cast<int>() : null;
    equipmentId =
        json['equipment_id'] is List ? json['equipment_id'].cast<int>() : null;
    id = json['id'];
    maintenanceTeamId = json['maintenance_team_id'] is List
        ? json['maintenance_team_id'].cast<int>()
        : null;
    requestDate = json['request_date'];
    stageId = json['stage_id'] is List ? json['stage_id'].cast<int>() : null;

    userId = json['user_id'] is List ? json['user_id'].cast<int>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    // data['employee_id'] = this.employeeId;
    data['equipment_id'] = this.equipmentId;
    data['id'] = this.id;
    data['maintenance_team_id'] = this.maintenanceTeamId;
    data['request_date'] = this.requestDate;
    data['stage_id'] = this.stageId;
    data['user_id'] = this.userId;
    return data;
  }
}
