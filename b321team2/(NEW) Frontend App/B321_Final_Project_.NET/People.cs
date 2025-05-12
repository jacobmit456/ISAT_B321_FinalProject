
using System;

public class clsPeople
{

    #region Properties 
    public int mPeopleID;
    public string mFName = "";
    public string mLName = "";
    public string mEmail = "";
    public string mACMID = "";
    public string mClassification = "";
    public string mStudentVIPID = "";
    public string mPaymentDate;
    public string mOrganization = "";

    #endregion

    #region Accessors
    public int PeopleID { get => mPeopleID; set => mPeopleID = value; }
    public string FName { get => mFName; set => mFName = value.Trim(); }
    public string LName { get => mLName; set => mLName = value.Trim(); }
    public string Email { get => mEmail; set => mEmail = value.Trim(); }
    public string ACMID { get => mACMID; set => mACMID = value.Trim(); }
    public string Classification { get => mClassification; set => mClassification = value.Trim(); }
    public string StudentVIPID { get => mStudentVIPID; set => mStudentVIPID = value.Trim(); }
    public string PaymentDate { get => mPaymentDate; set => mPaymentDate = value; }
    public string Organization { get => mOrganization; set => mOrganization = value.Trim(); }    
    #endregion

    public clsPeople()
    {

    }

    public clsPeople(int PeopleID)
    { 
    mPeopleID = PeopleID;
    }

}

