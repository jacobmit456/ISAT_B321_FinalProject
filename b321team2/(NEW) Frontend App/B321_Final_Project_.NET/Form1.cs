using System;
using System.CodeDom;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.Drawing;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace B321_Final_Project_.NET
{
    public partial class frmMain : Form
    {
        // Dictionary definitions
        private Dictionary<int, clsPeople> dctPeople = new Dictionary<int, clsPeople>();
        private Dictionary<int, clsOfficers> dctOfficers = new Dictionary<int, clsOfficers>();
        private Dictionary<int, clsEvents> dctEvents = new Dictionary<int, clsEvents>();
        private Dictionary<int, clsEventAttendees> dctEventAttendees = new Dictionary<int, clsEventAttendees>();
        private Dictionary<int, clsLocations> dctLocations = new Dictionary<int, clsLocations>();
        private Dictionary<int, clsAcademicYears> dctAcademicYears = new Dictionary<int, clsAcademicYears>();



        public frmMain()
        {
            InitializeComponent();
            // Disables all tabs until a sucessfull connection is reached.
            DisableAllTabs();
        } // end method frmMain

        private void Form1_Load(object sender, EventArgs e)
        {
            populatePeopleDictionary();
            populateEventsDictionary();
            populateOfficersDictionary();
            populateLocationsDictionary();
            populateEventAttendeesDictionary();
            populateAcademicYearsDictionary();
        } // end method Form1_Load

        #region ConnectionString
        // Connection String for SQL server Database
        private bool isConnected = false;
        private string getConnectionString()
        {
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = "b321team2.database.windows.net";
            builder.InitialCatalog = "B321Team2";
            builder.UserID = "JAM77";
            builder.Password = "Stangs4532";
            builder.TrustServerCertificate = true;
            builder.Encrypt = false;

            return builder.ConnectionString.ToString();
        } // end method getConnectionString
        #endregion

        // Connection Button
        private void btnConnectHome_Click(object sender, EventArgs e)
        {
            // Create a connection to the database
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // Refresh methods
                refreshOfficersDataGrid();
                refreshPeopleDataGrid();
                refreshEventsDataGrid();
                refreshEventAttendeesDataGrid();
                refreshMembershipRecordsDataGrid();
                refreshLocationsDataGrid();
                refreshAccountsDataGrid();
                refreshExpendituresLineItemsDataGrid();
                refreshExpendituresDataGrid();
                refreshRecievablesDataGrid();
                refreshRecievablesLineItemsDataGrid();

                try
                {
                    // Automatically takes the user to the people tab if connection was sucessful.
                    connection.Open();
                    isConnected = true;
                    EnableTabs();
                    MessageBox.Show("Successfully Connected!");
                    tabMain.SelectedTab = tabPeople;
                } // end try
                catch (Exception ex)
                {
                    MessageBox.Show($"Failed to connect: {ex.Message}");
                } // end catch
            } // end using
        } // end btnConnection

        #region Refresh Buttons 
        private void refreshPeopleDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM People";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvSearchPeople.DataSource = dt;
            } // end using
        } // end method refreshPeopleDataGrid

        private void refreshOfficersDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {

                {
                    string query = "SELECT * FROM Officers";
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvOfficerList.DataSource = dt;
                }
            } // end using
        } // end method refreshOfficersDataGrid

        private void refreshEventAttendeesDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM EventAttendees";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgv_EventAttendees.DataSource = dt;
            } // end using
        } // end method refreshEventAttendeesDataGrid

        private void refreshEventsDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Events";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvEventList.DataSource = dt;
            } // end using
        } // end method refreshEventsDataGrid

        private void refreshMembershipRecordsDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM MembershipRecords";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dataGridView3.DataSource = dt;
            } // end using
        } // end method refreshMembershipRecordsDataGrid

        private void refreshLocationsDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Locations";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvLocations.DataSource = dt;
            } // end using
        } // end method refreshLocationsDataGrid

        private void refreshAccountsDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM AccountingAccounts";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvAccounts.DataSource = dt;
            } // end using
        } // end method refreshAccountsDataGrid

        private void refreshExpendituresDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Expenditures";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvExpenditures.DataSource = dt;
            } // end using
        } // end method refreshExpendituresDataGrid

        private void refreshExpendituresLineItemsDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM ExpenditureLineItems";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvExpenditureLineItems.DataSource = dt;
            } // end using
        } // end method refreshExpendituresLineItemsDataGrid

        private void refreshRecievablesDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Recievables";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvRecievables.DataSource = dt;
            } // end using
        } // end method refreshRecievablesDataGrid

        private void refreshRecievablesLineItemsDataGrid()
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM RecievableLineItems";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvReceivableLineItems.DataSource = dt;
            } // end using
        } // end method refreshRecievablesLineItemsDataGrid

        #endregion

        #region Enable/Disable Tabs

        // Method to enable tabs after successful connection
        private void EnableTabs()
        {
            // Enable tabs only if the connection is successful
            if (isConnected)
            {
                // Enable all tabs
                foreach (TabPage tab in tabMain.TabPages)
                {
                    tab.Enabled = true;
                } // end foreach

                // Assuming tabMain is the name of your TabControl
                // Select the first tab by default
                tabMain.SelectedIndex = 0;
            } // end if
        } // end method EnableTabs


        // Method to disable all tabs except for the home tab until 
        // a sucessful connection is reached. 
        private void DisableAllTabs()
        {
            // Disable all tabs
            foreach (TabPage tab in tabMain.TabPages)
            {
                if (tab != tabHomePage)
                {
                    tab.Enabled = false;
                } // end if
            } // end foreach
        } // end method DisableAllTabs

        #endregion

        #region Private Helper Methods: Data-to-C# conversions
        private string convertFromDBType_DateToString(object obj)
        {
            if ((obj == null) || DBNull.Value.Equals(obj))
            {
                return string.Empty;
            } // end if
            else
            {
                DateTime temp = (DateTime)obj;
                return temp.ToShortDateString();
            } // end else
        } // end method convertFromDBType_DateToString

        private string convertFromDBType_VarcharToString(object obj)
        {
            if ((obj == null) || DBNull.Value.Equals(obj))
            {
                return string.Empty;
            } // end if
            else
            {
                return (string)obj;
            } // end else
        } // end method convertFromDBType_VarcharToString

        private string convertToDBType_BoolToBool(bool boolValue)
        {
            return boolValue.ToString();
        } // end method convertToDBType_BoolToBool

        private string convertToDBType_StringToVarchar(string stringValue)
        {
            return "'" + stringValue.Replace("'", "''") + "'";
        } // end method convertToDBType_StringToVarchar

        private string convertToDBType_StringToDate(string stringValue)
        {
            if (stringValue == "")
            {
                return "NULL";
            } // end if
            else
            {
                return "'" + stringValue.Replace("'", "''") + "'";
            } // end else
        } // end method convertToDBType_StringToDate

        #endregion

        #region People

        /**
         * This region manages the ACM members, officers, and membership records.
         * It includes methods for populating dictionaries with data from a SQL database,
         * refreshing data grids, adding new members, updating member information,
         * and searching for members.
         */
        private void populatePeopleDictionary()
        {

            string connectionString = getConnectionString();

            // create the connection
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_GetPeopleData", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctPeople.Clear();
                        while (rdr.Read() == true)
                        {
                            clsPeople currentPeople = new clsPeople();

                            currentPeople.PeopleID = (int)rdr["PeopleID"];
                            currentPeople.FName = convertFromDBType_VarcharToString(rdr["FName"]);
                            currentPeople.LName = convertFromDBType_VarcharToString(rdr["LName"]);
                            currentPeople.Email = convertFromDBType_VarcharToString(rdr["Email"]);
                            currentPeople.ACMID = convertFromDBType_VarcharToString(rdr["ACMID"]);
                            currentPeople.Classification = convertFromDBType_VarcharToString(rdr["Classification"]);
                            currentPeople.StudentVIPID = convertFromDBType_VarcharToString(rdr["StudentVIPID"]);
                            currentPeople.PaymentDate = convertFromDBType_DateToString(rdr["PaymentDate"]);
                            currentPeople.Organization = convertFromDBType_VarcharToString(rdr["Organization"]);

                            dctPeople.Add(currentPeople.PeopleID, currentPeople);
                        } // end while
                    } // end using
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to populate People: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method populatePeopleDictionary


        // Need to figure out why sp is populating twice
        private void btnAddPerson_anp_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertPerson", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    // Add the parameters for the stored procedurecommand.Parameters.AddWithValue("@LName", txtLastName_anp.Text);

                    //command.Parameters.Add(new SqlParameter("@Lname", SqlDbType.VarChar, 50));
                    command.Parameters.AddWithValue("@LName", txtLastName_anp.Text);

                    //command.Parameters.Add(new SqlParameter("@Fname", SqlDbType.VarChar, 50));
                    command.Parameters.AddWithValue("@FName", txtFirstName_anp.Text);

                    //command.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 50));
                    command.Parameters.AddWithValue("@Email", txtEmail_anp.Text);

                    if (txtACMID_anp.TextLength > 0 && txtACMID_anp.TextLength != 7)
                    {
                        MessageBox.Show("Error: A person's ACM ID must be 7 digits long!");
                        return;
                    } // end if
                    else
                    {
                        command.Parameters.AddWithValue("@ACMID", txtACMID_anp.Text);
                    } // end else
                    string selectedClassification = cboClassification_anp.Text;
                    string[] validClassifications = { "External", "Student", "Freshman", "Sophomore", "Junior", "Graduate", "Alumni", "Representative", "Coordinator", "Faculty" };
                    if (!validClassifications.Contains(selectedClassification))
                    {
                        MessageBox.Show("Error: A person's classification must be one of the preset options!");
                        return;
                    } // end if

                    command.Parameters.AddWithValue("@Classification", cboClassification_anp.Text);

                    command.Parameters.AddWithValue("@StudentVIPID", txtVIPID_anp.Text);

                    if (CheckDidNotPay_anp.Checked == true)
                    {
                        command.Parameters.AddWithValue("@PaymentDate", DBNull.Value);
                    } // end if
                    else
                    {
                        command.Parameters.AddWithValue("@PaymentDate", dtpPaymentDate_anp.Value);
                    } // end else


                    command.Parameters.AddWithValue("@Organization", txtOrganization_anp.Text);

                    // use the sql Data reader to read data from the sql query set.
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctPeople.Clear();
                        while (rdr.Read() == true)
                        {
                            clsPeople currentPeople = new clsPeople();

                            // currentLocation.LocationID = (int)rdr["LocationID"];
                            currentPeople.FName = rdr["FName"].ToString();


                            dctPeople.Add(currentPeople.PeopleID, currentPeople);
                        } // end while
                    } // end using
                    // Output message if the entry was sucessful 
                    MessageBox.Show("The entry for " + txtFirstName_anp.Text + " " + txtLastName_anp.Text + " was saved succsessfully!");
                } // end try
                catch (Exception)
                {
                    // error message, if the insert failed. 
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    // Close the connection and populate the dictionary.
                    connection.Close();
                    refreshPeopleDataGrid();
                    populatePeopleDictionary();
                } // end finally
            } // end using
        } // end method btnAddPerson_anp_Click

        private void btnExit_anp_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_anp_Click

        // Works but need to figure out error handling and error message issue. 
        private void btnSaveChanges_eep_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdatePersonByID", connection);
                    command.CommandType = CommandType.StoredProcedure;


                    command.Parameters.AddWithValue("@PeopleID", txt_PeopleID_eep.Text);
                    command.Parameters.AddWithValue("@NewLName", txtLastName_eep.Text);
                    command.Parameters.AddWithValue("@NewFName", txtFirstName_eep.Text);
                    command.Parameters.AddWithValue("@NewACMID", txtACMID_eep.Text);
                    command.Parameters.AddWithValue("@NewEmail", txtEmail_eep.Text);
                    command.Parameters.AddWithValue("@NewClassification", cboClassification_eep.Text);
                    command.Parameters.AddWithValue("@NewStudentVIPID", txtVIPID_eep.Text);
                    command.Parameters.AddWithValue("@NewPaymentDate", dtpPaymentDate_eep.Value);
                    command.Parameters.AddWithValue("@NewOrganization", txtOrganization_eep.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                MessageBox.Show("The entry was Updated succsessfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                    refreshPeopleDataGrid();
                    populatePeopleDictionary();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eep_Click

        private void btnSearch_eep_Click(object sender, EventArgs e)
        {
            refreshPeopleDataGrid();
        } // end method btnSearch_eep_Click

        #endregion People

        #region Events

        /**
         * This region manages ACM events, including methods for populating the events dictionary
         * with data from a SQL database, adding new events, and updating event information.
         * 
         * Populates the Events Dictionary and converts data types.
         */

        private void populateEventsDictionary()
        {

            string connectionString = getConnectionString();

            // create the connection
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_GetEventsData", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctEvents.Clear();
                        while (rdr.Read() == true)
                        {
                            clsEvents currentEvent = new clsEvents();

                            currentEvent.EventID = (int)rdr["EventID"];
                            currentEvent.EventName = convertFromDBType_VarcharToString(rdr["EventName"]);
                            currentEvent.Description = convertFromDBType_VarcharToString(rdr["Description"]);
                            currentEvent.EventStartTime = convertFromDBType_DateToString(rdr["EventStartTime"]);
                            currentEvent.EventEndTime = convertFromDBType_DateToString(rdr["EventEndTime"]);
                            currentEvent.LocationID = rdr["LocationID"] == DBNull.Value ? 0 : (int)rdr["LocationID"];
                            currentEvent.OfficerID = rdr["OfficerID"] == DBNull.Value ? 0 : (int)rdr["OfficerID"];

                            dctEvents.Add(currentEvent.EventID, currentEvent);

                        } // end while

                    } // end using

                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to populate Events: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method populateEventsDictionary

        private void btnAddEvent_ane_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertEventInformation", connection);
                    command.CommandType = CommandType.StoredProcedure;


                    command.Parameters.AddWithValue("@NewEventName", txtName_ane.Text);

                    command.Parameters.AddWithValue("@NewDescription", txtDescription_ane.Text);

                    command.Parameters.AddWithValue("@NewEventStartTime", dtpStartTime_ane.Value);

                    command.Parameters.AddWithValue("@NewEventEndTime", dtpEndTime_ane.Value);

                    command.Parameters.AddWithValue("@NewLocationID", txtLocationID_ane.Text);

                    command.Parameters.AddWithValue("@NewOfficerID", txtOfficerID_ane.Text);

                    command.ExecuteNonQuery();


                    MessageBox.Show("The entry for " + txtName_ane.Text + " was saved succsessfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                    populateEventsDictionary();
                } // end finally
            } // end using
        } // end method btnAddEvent_ane_Click

        #endregion

        #region Officers 
        // Populates the Officers Dictionary and converts data types.
        private void populateOfficersDictionary()
        {

            string connectionString = getConnectionString();

            // create the connection
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_GetOfficersData", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctOfficers.Clear();
                        while (rdr.Read() == true)
                        {
                            clsOfficers currentOfficers = new clsOfficers();

                            currentOfficers.OfficerID = (int)rdr["OfficerID"];
                            currentOfficers.PeopleID = (int)rdr["PeopleID"];
                            currentOfficers.Position = convertFromDBType_VarcharToString(rdr["Position"]);
                            currentOfficers.StartDate = convertFromDBType_DateToString(rdr["StartDate"]);
                            currentOfficers.EndDate = convertFromDBType_DateToString(rdr["EndDate"]);


                            dctOfficers.Add(currentOfficers.OfficerID, currentOfficers);
                        } // end while
                    } // end using
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to populate Officers: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method populateOfficersDictionary

        // Inserts a new officer button 
        private void Btn_AddNew_no(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertOfficer", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@PeopleID", txtPeopleID_o.Text);
                    command.Parameters.AddWithValue("@Position", cboPosition_o.Text);
                    command.Parameters.AddWithValue("@StartDate", dtpStartDate_o.Text);
                    command.Parameters.AddWithValue("@EndDate", dtpEndDate_o.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry for ___ was saved succsessfully!");

                } // end try

                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                    populateOfficersDictionary();
                } // end finally
            } // end using
        } // end method Btn_AddNew_no

        private void btn_EditOfficer_no_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateOfficerByID", connection);
                    command.CommandType = CommandType.StoredProcedure;


                    command.Parameters.AddWithValue("@OfficerID", txtOfficerID_o.Text);
                    command.Parameters.AddWithValue("@NewPeopleID", txtPeopleID_o.Text);
                    command.Parameters.AddWithValue("@NewPosition", cboPosition_o.Text);
                    command.Parameters.AddWithValue("@NewStartDate", dtpStartDate_o.Value);
                    command.Parameters.AddWithValue("@NewEndDate", dtpEndDate_o.Value);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                }
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                }
                finally
                {
                    connection.Close();
                    populatePeopleDictionary();
                }
            }
        } // end method btn_editOfficer_no_Click

        #endregion

        #region Locations

        /**
         * This region manages locations for ACM events, including methods for populating the locations dictionary
         * with data from a SQL database, adding new locations, and updating location information.
         */

        private void populateLocationsDictionary()
        {

            string connectionString = getConnectionString();

            // create the connection
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_GetLocationsData", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctLocations.Clear();
                        while (rdr.Read() == true)
                        {
                            clsLocations currentLocation = new clsLocations();

                            currentLocation.LocationID = (int)rdr["LocationID"];
                            currentLocation.Name = convertFromDBType_VarcharToString(rdr["Name"]);
                            currentLocation.Description = convertFromDBType_VarcharToString(rdr["Description"]);
                            currentLocation.Building = convertFromDBType_VarcharToString(rdr["Building"]);
                            currentLocation.Room = convertFromDBType_VarcharToString(rdr["Room"]);
                            currentLocation.Address1 = convertFromDBType_VarcharToString(rdr["Address1"]);
                            currentLocation.Address2 = convertFromDBType_VarcharToString(rdr["Address2"]);
                            currentLocation.City = convertFromDBType_DateToString(rdr["City"]);
                            currentLocation.State = convertFromDBType_VarcharToString(rdr["State"]);
                            currentLocation.ZipCode = convertFromDBType_VarcharToString(rdr["ZipCode"]);

                            dctLocations.Add(currentLocation.LocationID, currentLocation);
                        } // end while
                    } // end using

                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to populate Locations: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method populateLocationsDictionary

        private void btnAddLocation_anl_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertLocation", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Name", txtName_anl.Text);
                    command.Parameters.AddWithValue("@Description", txtDescription_anl.Text);
                    command.Parameters.AddWithValue("@Building", txtBuilding_anl.Text);
                    command.Parameters.AddWithValue("@Room", txtRoom_anl.Text);
                    command.Parameters.AddWithValue("@Address1", txtAddress1_anl.Text);
                    command.Parameters.AddWithValue("@Address2", txtAddress2_anl.Text);
                    command.Parameters.AddWithValue("@City", txtCity_anl.Text);
                    command.Parameters.AddWithValue("@State", txtState_anl.Text);
                    command.Parameters.AddWithValue("@ZipCode", txtZipCode_anl.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry was saved succsessfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnAddLocation_anl_Click

        private void btnSaveChanges_eel_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateLocationByID", connection);
                    command.CommandType = CommandType.StoredProcedure;


                    command.Parameters.AddWithValue("@LocationID", txtLocationID_eel.Text);
                    command.Parameters.AddWithValue("@NewName", txtName_eel.Text);
                    command.Parameters.AddWithValue("@NewDescription", txtDescription_eel.Text);
                    command.Parameters.AddWithValue("@NewBuilding", txtBuilding_eel.Text);
                    command.Parameters.AddWithValue("@NewRoom", txtRoom_eel.Text);
                    command.Parameters.AddWithValue("@NewAddress1", txtAddress1_eel.Text);
                    command.Parameters.AddWithValue("@NewAddress2", txtAddress2_eel.Text);
                    command.Parameters.AddWithValue("@NewCity", txtCity_eel.Text);
                    command.Parameters.AddWithValue("@NewState", txtState_eel.Text);
                    command.Parameters.AddWithValue("@NewZipCode", txtZipCode_eel.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using 
        } // end method btnSaveChanges_eel_Click

        #endregion

        #region EventAttendees 

        private void populateEventAttendeesDictionary()
        {

            string connectionString = getConnectionString();

            // create the connection
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_GetEventAttendees", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctEventAttendees.Clear();
                        while (rdr.Read() == true)
                        {
                            clsEventAttendees currentLocation = new clsEventAttendees();

                            currentLocation.EventAttendeeID = (int)rdr["EventAttendeeID"];
                            currentLocation.EventID = convertFromDBType_VarcharToString(rdr["EventID"]);
                            currentLocation.PeopleID = convertFromDBType_VarcharToString(rdr["PeopleID"]);

                            dctEventAttendees.Add(currentLocation.EventAttendeeID, currentLocation);
                        } // end while
                    } // end using

                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to populate Event Attendees: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method populateEventAttendeesDictionary


        #endregion

        #region AcademicYears



        #endregion

        #region GLAccounts



        #endregion

        private void btnExit_ane_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_ane_Click

        private void btnExit_eep_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eep_Click

        private void btnExit_o_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_o_Click

        private void btnExit_mr_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_mr_Click

        private void btnExit_eee_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eee_Click

        private void btnExit_aea_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_aea_Click

        private void btnExit_ael_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_ael_Click

        private void btnExit_anl_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_anl_Click

        private void btnExit_eel_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eel_Click

        private void txtPeopleID_anp_TextChanged(object sender, EventArgs e)
        {

        } // end method txtPeopleID_anp_TextChanged

        private void lvwAddEventAttendees_SelectedIndexChanged(object sender, EventArgs e)
        {

        } // end method lvwAddEventAttendees_SelectedIndexChanged

        private void frmMain_Load(object sender, EventArgs e)
        {

        } // end method frmMain_Load

        private void fillByToolStripButton_Click(object sender, EventArgs e)
        {
            try
            {
                //this.peopleTableAdapter.FillBy(this.b321Team2DataSet.People);
            } // end try
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            } // end catch

        } // end method fillByToolStripButton_Click

        private void txtEmail_eep_TextChanged(object sender, EventArgs e)
        {

        } // end method txtEmail_eep_TextChanged

        private void dgvOfficerList_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dgvOfficerList_CellContentClick

        private void tabOfficers_Click(object sender, EventArgs e)
        {

        } // end method tabOfficers_Click

        private void tabAddNewPerson_Click(object sender, EventArgs e)
        {

        } // end method tabAddNewPerson_Click

        private void cboClassification_anp_SelectedIndexChanged(object sender, EventArgs e)
        {

        } // end method cboClassification_anp_SelectedIndexChanged

        private void dgvEditExistingPerson_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dgvEditExistingPerson_CellContentClick



        private void dataGridView4_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dataGridView4_CellContentClick

        private void dataGridView6_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dataGridView6_CellContentClick

        private void tabMembershipRecords_Click(object sender, EventArgs e)
        {

        } // end method tabMembershipRecords_Click

        private void dataGridView8_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Note: Run sp_YearlyMemberReport  here and execute using an academic year 
            // if we have time, the goal is to make a printable report. 
        } // end method dataGridView8_CellContentClick

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Note: Run sp_EventAttendance here and execute using an academic year 
        } // end method dataGridView1_CellContentClick


        private void txt_PeopleID_eep_TextChanged(object sender, EventArgs e)
        {

        } // end method txt_PeopleID_eep_TextChanged

        private void txtName_ane_TextChanged(object sender, EventArgs e)
        {

        } // end method txtName_ane_TextChanged

        private void fillBy1ToolStripButton_Click(object sender, EventArgs e)
        {
            try
            {
                //this.peopleTableAdapter.FillBy(this.b321Team2DataSet.People);
            } // end try
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            } // end catch

        } // end method fillBy1ToolStripButton_Click

        private void fillBy1ToolStrip_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        } // end method fillBy1ToolStrip_ItemClicked

        private void fillByToolStripButton_Click_1(object sender, EventArgs e)
        {
            try
            {
                //this.officersTableAdapter.FillBy(this.b321Team2DataSet.Officers);
            } // end try
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            } // end catch
        } // end method fillByToolStripButton_Click_1

        private void lblDescription_eea_Click(object sender, EventArgs e)
        {

        } // end method lblDescription_eea_Click

        private void txtRoutingNumber_eea_TextChanged(object sender, EventArgs e)
        {

        } // end method txtRoutingNumber_eea_TextChanged

        private void txtDescription_eea_TextChanged(object sender, EventArgs e)
        {

        } // end method txtDescription_eea_TextChanged

        private void lblAccountNumber_eea_Click(object sender, EventArgs e)
        {

        } // end method lblAccountNumber_eea_Click

        private void lblRoutingNumber_eea_Click(object sender, EventArgs e)
        {

        } // end method lblRoutingNumber_eea_Click

        private void txtAccountNumber_eea_TextChanged(object sender, EventArgs e)
        {

        } // end method txtAccountNumber_eea_TextChanged

        private void dataGridView3_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dataGridView3_CellContentClick

        private void tabEditExistingPerson_Click(object sender, EventArgs e)
        {

        } // end method tabEditExistingPerson_Click

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        } // end method pictureBox1_Click

        private void btnSearch_ano_Click(object sender, EventArgs e)
        {
            refreshOfficersDataGrid();
        } // end method btnSearch_ano_Click


        private void dgvSearchPeople_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dgvSearchPeople_CellContentClick

        private void button4_Click(object sender, EventArgs e)
        {
            refreshEventsDataGrid();
        } // end method button4_Click

        private void btnSearch_mr_Click(object sender, EventArgs e)
        {
            refreshMembershipRecordsDataGrid();
        } // end method btnSearch_mr_Click

        private void btnSearch_eea_Click(object sender, EventArgs e)
        {
            refreshEventAttendeesDataGrid();
        } // end method btnSearch_eea_Click

        private void dgvLocations_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        } // end method dgvLocations_CellContentClick

        private void btnSearch_eel_Click(object sender, EventArgs e)
        {
            refreshLocationsDataGrid();
        } // end method btnSearch_eel_Click

        private void btnSearchAccounts_Click(object sender, EventArgs e)
        {
            refreshAccountsDataGrid();
        } // end method btnSearchAccounts_Click

        private void btnSearchExpenditures_Click(object sender, EventArgs e)
        {
            refreshExpendituresDataGrid();
        } // end method btnSearchExpenditures_Click

        private void btnSearchExpenditureLineItems_Click(object sender, EventArgs e)
        {
            refreshExpendituresLineItemsDataGrid();
        } // end method btnSearchExpenditureLineItems_Click

        private void btnExit_ana_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_ana_Click

        private void btnExit_eea_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eea_Click

        private void btnExit_anx_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_anx_Click

        private void btnExit_eex_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eex_Click

        private void btnExit_aneli_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_aneli_Click

        private void btnExit_eeeli_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eeeli_Click

        private void btnExit_anr_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_anr_Click

        private void btnExit_eer_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eer_Click



        private void radDidNotPay_anp_CheckedChanged(object sender, EventArgs e)
        {

        } // end method radDidNotPay_anp_CheckedChanged

        private void btnSaveChanges_eee_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateEventByID", connection);
                    command.CommandType = CommandType.StoredProcedure;


                    command.Parameters.AddWithValue("@EventID", txtEventID_eee.Text);
                    command.Parameters.AddWithValue("@NewOfficerID", txtOfficerID_eee.Text);
                    command.Parameters.AddWithValue("@NewEventName", txtName_eee.Text);
                    command.Parameters.AddWithValue("@NewDescription", txtDescription_eee.Text);
                    command.Parameters.AddWithValue("@NewEventStartTime", dtpStartTime_eee.Value);
                    command.Parameters.AddWithValue("@NewEventEndTime", dtpEndTime_eee.Value);
                    command.Parameters.AddWithValue("@NewLocationID", txtLocationID_eee.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eee_Click

        private void btnAddAttendee_aea_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertEventAttendee", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@EventID", txtEventID_aea.Text);
                    command.Parameters.AddWithValue("@PeopleID", txtPeopleID_aea.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry for ___ was saved succsessfully!");

                } // end try

                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnAddAttendee_aea_Click

        private void txtName_eee_TextChanged(object sender, EventArgs e)
        {

        } // end method txtName_eee_TextChanged

        private void btnExit_vea_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_vea_Click

        private void btnExit_ACM_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_ACM_Click

        private void btnExit_anrli_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_anrli_Click

        private void btnExit_eerli_Click(object sender, EventArgs e)
        {
            // Display a confirmation dialog
            DialogResult result = MessageBox.Show("Are you sure you want to exit?", "Exit Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                // If the user chooses "Yes", close the application
                Close();
            } // end if
        } // end method btnExit_eerli_Click

        private void btnSaveChanges_ea_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateEventAttendeeByID", connection);
                    command.CommandType = CommandType.StoredProcedure;


                    command.Parameters.AddWithValue("@EventAttendeeID", txtEventAttendeeID_aea.Text);
                    command.Parameters.AddWithValue("@NewEventID", txtEventID_aea.Text);
                    command.Parameters.AddWithValue("@NewPeopleID", txtPeopleID_aea.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update.");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_ea_Click

        private void btnAddAccount_ana_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertAccount", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@AccountDescription", txtDescription_ana.Text);
                    command.Parameters.AddWithValue("@RoutingNumber", txtRoutingNumber_ana.Text);
                    command.Parameters.AddWithValue("@AccountNumber", txtAccountNumber_ana.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry was saved succsessfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnAddAccount_ana_Click

        private void btnSaveChanges_eea_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateAccountByID", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@AccountingID", txtAccountingID_eea.Text);
                    command.Parameters.AddWithValue("@NewAccountDescription", txtDescription_eea.Text);
                    command.Parameters.AddWithValue("@NewRoutingNumber", txtRoutingNumber_eea.Text);
                    command.Parameters.AddWithValue("@NewAccountNumber", txtAccountNumber_eea.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eea_Click

        private void btnAddExpenditure_anx_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertExpenditure", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@AccountingID", txtAccountingID_anx.Text);
                    command.Parameters.AddWithValue("@ExpenditureDate", dtpPaymentDate_anx.Value);
                    command.Parameters.AddWithValue("@OfficerID", txtOfficerID_anx.Text);
                    command.Parameters.AddWithValue("@Description", txtDescription_anx.Text);
                    command.Parameters.AddWithValue("@RecordLocator", txtRecordLocator_anx.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry was saved succsessfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnAddExpenditure_anx_Click

        private void btnSaveChanges_eex_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateExpenditureByID", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@ExpenditureID", txtExpenditureID_eex.Text);
                    command.Parameters.AddWithValue("@NewAccountingID", txtAccountingID_eex.Text);
                    command.Parameters.AddWithValue("@NewExpenditureDate", dtpPaymentDate_eex.Value);
                    command.Parameters.AddWithValue("@NewOfficerID", txtOfficerID_eex.Text);
                    command.Parameters.AddWithValue("@NewDescription", txtDescription_eex.Text);
                    command.Parameters.AddWithValue("@NewRecordLocator", txtRecordLocator_eex.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eex_Click

        private void btnAddLineItem_aneli_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertExpenditureLineItem", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@ExpenditureID", txtExpenditureID_aneli.Text);
                    command.Parameters.AddWithValue("@LineItemDescription", txtDescription_aneli.Text);
                    command.Parameters.AddWithValue("@UnitQuantity", txtUnitQuantity_aneli.Text);
                    command.Parameters.AddWithValue("@QuantityPerUnit", txtQuantityPerUnit_aneli.Text);
                    command.Parameters.AddWithValue("@UnitPrice", txtUnitPrice_aneli.Text);
                    command.Parameters.AddWithValue("@LineItemCategory", cboCategory_aneli.Text);
                    command.Parameters.AddWithValue("@LocationID", txtLocationID_aneli.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry was saved successfully!");

                } // end try

                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnAddLineItem_aneli_Click

        private void btnSaveChanges_eeeli_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateExpenditureLineItemByID", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@ExpenditureLineItemID", txtExpenditureLineItemID_eeeli.Text);
                    command.Parameters.AddWithValue("@NewExpenditureID", txtExpenditureID_eeeli.Text);
                    command.Parameters.AddWithValue("@NewLineItemDescription", txtDescription_eeeli.Text);
                    command.Parameters.AddWithValue("@NewUnitQuantity", txtUnitQuantity_eeeli.Text);
                    command.Parameters.AddWithValue("@NewQuantityPerUnit", txtQuantityPerUnit_eeeli.Text);
                    command.Parameters.AddWithValue("@NewUnitPrice", txtUnitPrice_eeeli.Text);
                    command.Parameters.AddWithValue("@NewLineItemCategory", cboCategory_eeeli.Text);
                    command.Parameters.AddWithValue("@NewLocationID", txtLocationID_eeeli.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eeeli_Click

        private void btnAddReceivable_anr_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertReceivable", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@PeopleID", txtPeopleID_anr.Text);
                    command.Parameters.AddWithValue("@AccountID", txtAccountingID_anr.Text);
                    command.Parameters.AddWithValue("@Description", txtDescription_anr.Text);
                    command.Parameters.AddWithValue("@PaidDate", dtpPaymentDate_anr.Value);
                    command.Parameters.AddWithValue("@RecordLocator", txtRecordLocator_anr.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry was saved succsessfully!");

                } // end try

                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnAddReceivable_anr_Click


        private void populateAcademicYearsDictionary()
        {

            string connectionString = getConnectionString();

            // create the connection
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_GetAcademicYearsData", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader rdr = command.ExecuteReader())
                    {
                        dctPeople.Clear();
                        while (rdr.Read() == true)
                        {
                            clsAcademicYears currentYear = new clsAcademicYears();

                            currentYear.AcademicTermsID = (int)rdr["AcademicYearID"];
                            currentYear.AcademicTerm = convertFromDBType_VarcharToString(rdr["AcademicYear"]);
                            currentYear.AcademicTerm = convertFromDBType_DateToString(rdr["TermStartDate"]);
                            currentYear.AcademicTerm = convertFromDBType_DateToString(rdr["TermEndDate"]);

                            dctAcademicYears.Add(currentYear.AcademicTermsID, currentYear);
                        } // end while

                    } // end using

                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to populate People: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method populateAcademicYearsDictionary

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Note: Create dictionary for academic years to convert datetime to a string.
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                if (cboAcademicYear_MemberList.SelectedItem.ToString() == "2023-2024")
                {
                    string query = "sp_YearlyMemberReport @AcademicYear = '23-24'";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgw.DataSource = dt;
                } // end if
                else if (cboAcademicYear_MemberList.SelectedItem.ToString() == "2022-2023")
                {
                    string query = "sp_YearlyMemberReport @AcademicYear = '22-23'";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgw.DataSource = dt;
                } // end else
                else if (cboAcademicYear_MemberList.SelectedItem.ToString() == "2021-2022")
                {
                    string query = "sp_YearlyMemberReport @AcademicYear = '21-22'";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgw.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_MemberList.SelectedItem.ToString() == "2020-2021")
                {
                    string query = "sp_YearlyMemberReport @AcademicYear = '20-21'";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgw.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_MemberList.SelectedItem.ToString() == "2019-2020")
                {
                    string query = "sp_YearlyMemberReport @AcademicYear = '19-20'";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgw.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_MemberList.SelectedItem.ToString() == "2018-2019")
                {
                    string query = "sp_YearlyMemberReport @AcademicYear = '18-19'";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgw.DataSource = dt;
                } // end else if
            } // end using
        } // end method comboBox1_SelectedIndexChanged



        private void btnExport_ACM_Click(object sender, EventArgs e)
        {

        } // end method btnExport_ACM_Click

        private void cboClassification_eep_SelectedIndexChanged(object sender, EventArgs e)
        {

        } // end method cboClassification_eep_SelectedIndexChanged

        private void cboAcademicYear_Eventatt_SelectedIndexChanged(object sender, EventArgs e)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                if (cboAcademicYear_Eventatt.SelectedItem.ToString() == "2023-2024")
                {
                    string query = "EXEC sp_EventAttendance @StartDate = '2023-08-21', @EndDate = '2024-08-14';";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvEventAttendance.DataSource = dt;
                } // end if 
                else if (cboAcademicYear_Eventatt.SelectedItem.ToString() == "2022-2023")
                {
                    string query = "EXEC sp_EventAttendance @StartDate = '2022-08-21', @EndDate = '2023-08-14';";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvEventAttendance.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_Eventatt.SelectedItem.ToString() == "2021-2022")
                {
                    string query = "EXEC sp_EventAttendance @StartDate = '2021-08-21', @EndDate = '2022-08-14';";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvEventAttendance.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_Eventatt.SelectedItem.ToString() == "2020-2021")
                {
                    string query = "EXEC sp_EventAttendance @StartDate = '2020-08-15', @EndDate = '2021-08-14';";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvEventAttendance.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_Eventatt.SelectedItem.ToString() == "2019-2020")
                {
                    string query = "EXEC sp_EventAttendance @StartDate = '2019-08-16', @EndDate = '2020-08-14';";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvEventAttendance.DataSource = dt;
                } // end else if
                else if (cboAcademicYear_Eventatt.SelectedItem.ToString() == "2018-2019")
                {
                    string query = "EXEC sp_EventAttendance @StartDate = '2018-08-14', @EndDate = '2019-08-14';";


                    // Create a SqlDataAdapter with the SqlCommand
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);

                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvEventAttendance.DataSource = dt;
                } // end else if
            } // end using
        } // end method cboAcademicYear_Eventatt_SelectedIndexChanged

        private void btnReceivables_eer_Click(object sender, EventArgs e)
        {
            refreshRecievablesDataGrid();
        } // end method btnRecievables 

        private void txtFirstName_eep_TextChanged(object sender, EventArgs e)
        {

        } // end method txtFirstName_eep_TextChanged

        private void displaytest(clsPeople currentPeople)
        {
        txt_PeopleID_eep.Text = currentPeople.PeopleID.ToString();
        } // end method displaytest
        private void tabHomePage_Click(object sender, EventArgs e)
        {

        } // end tabHomePage_Click

        private void radDidNotPay_eep_CheckedChanged(object sender, EventArgs e)
        {

        } // end method radDidNotPay_eep_CheckedChanged

        private void CheckDidNotPay_anp_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox checkBox = sender as CheckBox;

            if (checkBox != null)
            {
                if (checkBox.Checked)
                {
                    MessageBox.Show("The 'Did Not Pay' option was selected.");
                } // end inner if
                else
                {
                    MessageBox.Show("The 'Did Not Pay' option was unselected.");
                } // end else
            } // end outer if
        } // end method CheckDidNotPay_anp_CheckedChanged

        private void btnSearch_eerli_Click(object sender, EventArgs e)
        {
            refreshRecievablesLineItemsDataGrid();
        } // end btnSearch_eerli_Click

        private void btnAddReceivableLineItem_anrli_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_InsertReceivableLineItem", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@ReceivableID", txtReceivableID_anrli.Text);
                    command.Parameters.AddWithValue("@Item", txtItem_anrli.Text);
                    command.Parameters.AddWithValue("@UnitType", txtQuantity_anrli.Text);
                    command.Parameters.AddWithValue("@UnitCost", txtUnitCost_anrli.Text);
                    command.Parameters.AddWithValue("@UnitQuantity", txtUnitQuantity_anrli.Text);
                    command.Parameters.AddWithValue("@ExpenditureLineItemID", txtExpenditureli_anrli.Text);

                    command.ExecuteNonQuery();

                    MessageBox.Show("The entry was saved successfully!");

                }

                catch (Exception)
                {
                    MessageBox.Show("An error has occurred: ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            }
        } // end method btnAddReceivableLineItem_anrli_Click

        private void btnSaveChanges_eerli_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateReceivableLineItemByID", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@ReceivableLineItemID", txtReceivableLineItemID_eerli.Text);
                    command.Parameters.AddWithValue("@NewReceivableID", txtReceivableID_eerli.Text);
                    command.Parameters.AddWithValue("@NewItem", txtItem_eerli.Text);
                    command.Parameters.AddWithValue("@NewUnitType", txtQuantity_eerli.Text);
                    command.Parameters.AddWithValue("@NewUnitCost", txtUnitCost_eerli.Text);
                    command.Parameters.AddWithValue("@NewUnitQuantity", txtUnitQuantity_eerli.Text);
                    command.Parameters.AddWithValue("@NewExpenditureLineItemID", txtExpenditureliID_eerli.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eerli_Click

        private void btnSaveChanges_eer_Click(object sender, EventArgs e)
        {
            // String connection
            string connectionString = getConnectionString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Create the SQLCommand and identify it as a stored procedure
                    SqlCommand command = new SqlCommand("sp_UpdateReceivableByID", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@ReceivableID", txtReceivableID_eer.Text);
                    command.Parameters.AddWithValue("@NewPeopleID", txtPeopleID_eer.Text);
                    command.Parameters.AddWithValue("@NewAccountingID", txtAccountingID_eer.Text);
                    command.Parameters.AddWithValue("@NewDescription", txtDescription_eer.Text);
                    command.Parameters.AddWithValue("@NewPaidDate", dtpPaymentDate_eer.Text);
                    command.Parameters.AddWithValue("@NewRecordLocator", txtRecordLocator_eer.Text);

                    int rowsAffected = command.ExecuteNonQuery();

                    MessageBox.Show("The entry was updated successfully!");
                } // end try
                catch (Exception)
                {
                    MessageBox.Show("An error has occurred while trying to update ");
                } // end catch
                finally
                {
                    connection.Close();
                } // end finally
            } // end using
        } // end method btnSaveChanges_eer_Click

        #region Search Methods
        // With the help of Tyler Hlusek
        private void txtSearchPerson_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearchPerson.Text.Trim();
            SearchPeople(searchTerm);
        } // end method txtSearchPerson_TextChanged

        private void txtSearch_Officers_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_Officers.Text.Trim();
            SearchOfficers(searchTerm);
        } // end method txtSearch_Officers_TextChanged

        private void txt_Search_mr_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txt_Search_mr.Text.Trim();
            SearchMembershipRecords(searchTerm);
        } // end method txt_Search_mr_TextChanged

        private void txtSearch_Events_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_Events.Text.Trim();
            SearchEvents(searchTerm);
        } // end method txtSearch_Events_TextChanged

        private void txtSearch_EventAtt_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_EventAtt.Text.Trim();
            SearchEventAttendees(searchTerm);
        } // end method txtSearch_EventAtt_TextChanged

        private void txtSearch_Locations_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_Locations.Text.Trim();
            SearchLocations(searchTerm);
        } // end method txtSearch_Locations_TextChanged

        private void txtSearch_Expenditure_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_Expenditure.Text.Trim();
            SearchExpenditures(searchTerm);
        } // end method txtSearch_Expenditure_TextChanged

        private void txtSearch_eli_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_eli.Text.Trim();
            SearchExpenditureLineItems(searchTerm);
        } // end method txtSearch_eli_TextChanged

        private void txtSearch_Recievables_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_Recievables.Text.Trim();
            SearchRecievables(searchTerm);
        } // end method txtSearch_Recievables_TextChanged

        private void txtSearch_rli_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch_rli.Text.Trim();
            SearchRecievableLineItems(searchTerm);
        } // end method txtSearch_rli_TextChanged

        public void SearchPeople(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM People WHERE PeopleID LIKE @SearchTerm OR LName LIKE @SearchTerm OR FName LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvSearchPeople.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching people: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchPeople

        public void SearchOfficers(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM Officers WHERE OfficerID LIKE @SearchTerm OR Position LIKE @SearchTerm OR StartDate LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvOfficerList.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Officers: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchOfficers

        public void SearchEvents(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM Events WHERE EventID LIKE @SearchTerm OR OfficerID LIKE @SearchTerm OR EventName LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvEventList.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Events: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchEvents

        public void SearchLocations(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM Locations WHERE LocationID LIKE @SearchTerm OR Name LIKE @SearchTerm OR Building LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvLocations.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Locations: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchLocations

        public void SearchMembershipRecords(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM MembershipRecords WHERE MRecordID LIKE @SearchTerm OR PeopleID LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dataGridView3.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Membership Records: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchMembershipRecords

        public void SearchEventAttendees(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM EventAttendees WHERE EventAttendeeID LIKE @SearchTerm OR EventID LIKE @SearchTerm OR PeopleID LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgv_EventAttendees.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Event Attendees: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchEventAttendees

        public void SearchExpenditures(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM Expenditures WHERE ExpenditureID LIKE @SearchTerm OR AccountingID LIKE @SearchTerm OR OfficerID LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvExpenditures.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Expenditures: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchExpenditures

        public void SearchExpenditureLineItems(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM ExpenditureLineItems WHERE ExpenditureLineItemID LIKE @SearchTerm OR ExpenditureID LIKE @SearchTerm OR LineItemDescription LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvExpenditureLineItems.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Expenditures: " + ex.Message);
                }// end catch
            } // end using
        } // end method SearchExpenditureLineItems

        public void SearchRecievables(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM Recievables WHERE RecievableID LIKE @SearchTerm OR PeopleID LIKE @SearchTerm OR Description LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvRecievables.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Recievables: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchRecievables

        public void SearchRecievableLineItems(string searchTerm)
        {
            string connectionString = getConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataSet searchResults = new DataSet();
                SqlDataAdapter adapter = new SqlDataAdapter();

                try
                {
                    connection.Open();

                    string query = "SELECT * FROM RecievableLineItems WHERE RevievableLineItemID LIKE @SearchTerm OR Item LIKE @SearchTerm OR RecievableID LIKE @SearchTerm";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    adapter.SelectCommand = command;

                    adapter.Fill(searchResults);

                    dgvReceivableLineItems.DataSource = searchResults.Tables[0];
                } // end try
                catch (Exception ex)
                {

                    MessageBox.Show("Error searching Recievable Line Items: " + ex.Message);
                } // end catch
            } // end using
        } // end method SearchRecievableLineItems

        #endregion

        private void tabEditExistingReceivableLineItem_Click(object sender, EventArgs e)
        {

        } // end method tabEditExistingReceivableLineItem_Click

    } // end frmMain

} // end namespace
