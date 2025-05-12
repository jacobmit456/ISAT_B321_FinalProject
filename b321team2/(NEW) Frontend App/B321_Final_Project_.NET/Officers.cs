using System;

public class clsOfficers
{
    #region Properties 
    public int oOfficerID;
    public int oPersonID;
    public string mPosition = "";
    public string mStartDate = "";
    public string mEndDate = "";
    #endregion

    #region Accessors

    public int OfficerID { get => oOfficerID; set => oOfficerID = value; }
    public int PeopleID { get => oPersonID; set => oPersonID = value; }
    public string Position { get => mPosition; set => mPosition = value; }
    public string StartDate { get => mStartDate; set => mStartDate = value; }
    public string EndDate { get => mEndDate; set => mEndDate = value; }

    #endregion

    public clsOfficers()
    {

    }

    public clsOfficers(int OfficerID)
    {
        oOfficerID = OfficerID;
    }


}
