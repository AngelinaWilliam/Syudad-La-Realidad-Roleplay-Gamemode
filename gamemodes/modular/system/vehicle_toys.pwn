//By Taljzed#7014 kyutiee

enum e_vToys
{
    vtoy_modelid,
    vtoy_model,
    Float:vtoy_x,
    Float:vtoy_y,
    Float:vtoy_z,
    Float:vtoy_rx,
    Float:vtoy_ry,
    Float:vtoy_rz
}
new vtData[MAX_VEHICLES][2][e_vToys];

forward load_player_vehToys(vehicleid);
public load_player_vehToys(vehicleid)
{
	new rows = cache_num_rows(), vehid = VehicleInfo[vehicleid][vID];
 	if(rows)
  	{
		VehicleInfo[vehid][hasvToys] = true; //exists
		vtData[vehid][0][vtoy_modelid] = cache_get_field_content_int(0, "Slot0_Modelid");
  		vtData[vehid][0][vtoy_x] = cache_get_field_content_float(0, "Slot0_XPos");
  		vtData[vehid][0][vtoy_y] = cache_get_field_content_float(0, "Slot0_YPos");
  		vtData[vehid][0][vtoy_z] = cache_get_field_content_float(0, "Slot0_ZPos");
  		vtData[vehid][0][vtoy_rx] = cache_get_field_content_float(0, "Slot0_XRot");
  		vtData[vehid][0][vtoy_ry] = cache_get_field_content_float(0, "Slot0_YRot");
  		vtData[vehid][0][vtoy_ry] = cache_get_field_content_float(0, "Slot0_ZRot");

        vtData[vehid][1][vtoy_modelid] = cache_get_field_content_int(0, "Slot1_Modelid");
  		vtData[vehid][1][vtoy_x] = cache_get_field_content_float(0, "Slot1_XPos");
  		vtData[vehid][1][vtoy_y] = cache_get_field_content_float(0, "Slot1_YPos");
  		vtData[vehid][1][vtoy_z] = cache_get_field_content_float(0, "Slot1_ZPos");
  		vtData[vehid][1][vtoy_rx] = cache_get_field_content_float(0, "Slot1_XRot");
  		vtData[vehid][1][vtoy_ry] = cache_get_field_content_float(0, "Slot1_YRot");
  		vtData[vehid][1][vtoy_ry] = cache_get_field_content_float(0, "Slot1_ZRot");
    }
	AttachVehicleToys(vehid);
}

AttachVehicleToys(vehicleid)
{
	if(VehicleInfo[vehicleid][hasvToys] == false) return 1;

	if(vtData[vehicleid][0][vtoy_model] == 0)
	{
		vtData[vehicleid][0][vtoy_model] = CreateDynamicObject(vtData[vehicleid][0][vtoy_modelid],
 	 	vtData[vehicleid][0][vtoy_x],
		vtData[vehicleid][0][vtoy_y],
		vtData[vehicleid][0][vtoy_z],
		vtData[vehicleid][0][vtoy_rx],
		vtData[vehicleid][0][vtoy_ry],
		vtData[vehicleid][0][vtoy_rz]);

		AttachDynamicObjectToVehicle(vtData[vehicleid][0][vtoy_model],
		vehicleid,
		vtData[vehicleid][0][vtoy_x],
		vtData[vehicleid][0][vtoy_y],
		vtData[vehicleid][0][vtoy_z],
		vtData[vehicleid][0][vtoy_rx],
		vtData[vehicleid][0][vtoy_ry],
		vtData[vehicleid][0][vtoy_rz]);
	}
	if(vtData[vehicleid][1][vtoy_model] == 0)
	{
		vtData[vehicleid][1][vtoy_model] = CreateDynamicObject(vtData[vehicleid][1][vtoy_modelid],
 	 	vtData[vehicleid][1][vtoy_x],
		vtData[vehicleid][1][vtoy_y],
		vtData[vehicleid][1][vtoy_z],
		vtData[vehicleid][1][vtoy_rx],
		vtData[vehicleid][1][vtoy_ry],
		vtData[vehicleid][1][vtoy_rz]);

		AttachDynamicObjectToVehicle(vtData[vehicleid][1][vtoy_model],
		vehicleid,
		vtData[vehicleid][1][vtoy_x],
		vtData[vehicleid][1][vtoy_y],
		vtData[vehicleid][1][vtoy_z],
		vtData[vehicleid][1][vtoy_rx],
		vtData[vehicleid][1][vtoy_ry],
		vtData[vehicleid][1][vtoy_rz]);
	}
    return 1;
}

//reloadvehicle
reload_vtoys(vehicleid) {
    if(VehicleInfo[VehicleInfo[vehicleid][vID]][hasvToys] == true) { AttachVehicleToys(VehicleInfo[vehicleid][vID]); }
}

//pag nag despawned ng car or destroy
//ResetVehicle(vehicleid)

reset_vtoys(vehicleid) {

    if(vtData[VehicleInfo[vehicleid][vID]][0][vtoy_model] != INVALID_OBJECT_ID) {
        for(new z = 0; z < 2; z++)
        {
            vtData[vehicleid][z][vtoy_modelid] = 0;
            vtData[vehicleid][z][vtoy_x] = 0.0;
            vtData[vehicleid][z][vtoy_y] = 0.0;
            vtData[vehicleid][z][vtoy_z] = 0.0;
            vtData[vehicleid][z][vtoy_rx] = 0.0;
            vtData[vehicleid][z][vtoy_ry] = 0.0;
            vtData[vehicleid][z][vtoy_rz] = 0.0;
            DestroyObject(vtData[vehicleid][z][vtoy_model]);
        }
    }
}
