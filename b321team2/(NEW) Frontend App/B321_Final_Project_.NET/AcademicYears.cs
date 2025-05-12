using System;

    public class clsAcademicYears
    {
    #region Properties 

    public int mAcademicTermsID;
    public string mAcademicTerm = "";
    public string mTermStartDate = "";
    public string mTermEndDate = "";
    #endregion

    #region Accessors 

    public int AcademicTermsID { get => mAcademicTermsID; set => mAcademicTermsID = value; }
    public string AcademicTerm { get => mAcademicTerm; set => mAcademicTerm = value; }
    public string TermStartDate { get => mTermStartDate; set => mTermStartDate = value; }
    public string TermEndDate { get => mTermEndDate; set => mTermEndDate = value; }

    #endregion

    public clsAcademicYears()
    {

    }


    public clsAcademicYears(int LocationID)
    {
        mAcademicTermsID = AcademicTermsID;
    }

}

