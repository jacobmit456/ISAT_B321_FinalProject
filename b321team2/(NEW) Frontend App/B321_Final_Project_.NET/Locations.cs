using System;

public class clsLocations
{
    #region Properties 
    public int nLocationID;
    public string mName = "";
    public string mDescription = "";
    public string mBuilding = "";
    public string mRoom = "";
    public string mAddress1 = "";
    public string mAddress2 = "";
    public string mCity = "";
    public string mState = "";
    public string mZipCode = "";
    #endregion

    #region Accessors
    public int LocationID { get => nLocationID; set => nLocationID = value; }
    public string Name { get => mName; set => mName = value.Trim(); }
    public string Description { get => mDescription; set => mDescription = value.Trim(); }
    public string Building { get => mBuilding; set => mBuilding = value.Trim(); }
    public string Room { get => mRoom; set => mRoom = value.Trim(); }
    public string Address1 { get => mAddress1; set => mAddress1 = value.Trim(); }
    public string Address2 { get => mAddress2; set => mAddress2 = value.Trim(); }
    public string City { get => mCity; set => mCity = value; }
    public string State { get => mState; set => mState = value.Trim(); }
    public string ZipCode { get => mZipCode; set => mZipCode = value.Trim(); }
    #endregion

    public clsLocations()
    {

    }

    public clsLocations(int LocationID)
    {
        nLocationID = LocationID;
    }

}

