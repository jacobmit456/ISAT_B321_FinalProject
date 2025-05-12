using Microsoft.SqlServer.Server;
using System;

public class clsEventAttendees
{
    // Need to figure out how to deal with foreign keys? 
    #region Properties 

    public int mEventAttendeeID;
    public string mEventID = "";
    public string mPeopleID = "";

    #endregion

    #region Accessors 

    public int EventAttendeeID { get => mEventAttendeeID; set => mEventAttendeeID = value; }
    public string EventID { get => mEventID; set => mEventID = value; }
    public string PeopleID { get => mPeopleID; set => mPeopleID = value; }

    #endregion

    public clsEventAttendees()
    {

    }

    public clsEventAttendees(int EventAttendeeID)
    {
        mEventAttendeeID = EventAttendeeID;
    }

}
