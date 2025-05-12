using System;

public class clsEvents
{
    #region Properties 
    public int mEventID;
    public string mEventName = "";
    public string mDescription = "";
    public string mStartTime = "";
    public string mEndTime = "";
    public int mOfficerID;
    public int mLocationID;
    #endregion

    #region Accessors 
    public int EventID { get => mEventID; set => mEventID = value; }
    public string EventName { get => mEventName; set => mEventName = value.Trim(); }
    public string Description { get => mDescription; set => mDescription = value.Trim(); }
    public string EventStartTime { get => mStartTime; set => mStartTime = value.Trim(); }
    public string EventEndTime { get => mEndTime; set => mEndTime = value.Trim(); }
    public int OfficerID { get => mOfficerID; set => mOfficerID = value; }
    public int LocationID { get => mLocationID; set => mLocationID = value; }
    #endregion

    public clsEvents()
    {

    }

    public clsEvents(int EventID)
    {
        mEventID = EventID;
    }


}
