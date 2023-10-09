using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SoftwareDesignLab1
{
    public partial class Form1 : Form
    {
        private string connectionString;

        private SqlDataAdapter orderAdapter;
        private SqlDataAdapter tableAdapter;
        private SqlDataAdapter operatorAdapter;

        private SqlCommandBuilder orderBuilder = new SqlCommandBuilder();

        private DataSet dataSet = new DataSet();

        public Form1()
        {
            InitializeComponent();
            StartPosition = FormStartPosition.CenterScreen;

            connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DbConnection"].ConnectionString;

            orderAdapter = new SqlDataAdapter("Select * from TaxiOrder", connectionString);
            tableAdapter = new SqlDataAdapter("Select * from TaxiTable", connectionString);
            operatorAdapter = new SqlDataAdapter("Select * from TaxiOperator", connectionString);

            orderBuilder = new SqlCommandBuilder(orderAdapter);

            orderAdapter.Fill(dataSet, "order");
            tableAdapter.Fill(dataSet, "table");
            operatorAdapter.Fill(dataSet, "operator");

            dataGridView1.DataSource = dataSet.Tables["order"];

            FillComboBox1();
            FillTableCombobox();
            FillOperatorCombobox();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void DeleteButton_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dataGridView1.SelectedRows)
            {
                dataGridView1.Rows.Remove(row);
            }
        }

        private void UpdateButton_Click(object sender, EventArgs e)
        {
            orderAdapter.Update(dataSet, "order");
        }

        private void FillTableCombobox()
        {
            ((DataGridViewComboBoxColumn)dataGridView1.Columns["order_table_id"]).DataSource =
                dataSet.Tables["table"];
            ((DataGridViewComboBoxColumn)dataGridView1.Columns["order_table_id"]).DisplayMember =
                "table_date_start";
            ((DataGridViewComboBoxColumn)dataGridView1.Columns["order_table_id"]).ValueMember =
                "table_id";
        }

        private void FillOperatorCombobox()
        {
            ((DataGridViewComboBoxColumn)dataGridView1.Columns["order_operator_id"]).DataSource =
                dataSet.Tables["operator"];
            ((DataGridViewComboBoxColumn)dataGridView1.Columns["order_operator_id"]).DisplayMember =
                "operator_name";
            ((DataGridViewComboBoxColumn)dataGridView1.Columns["order_operator_id"]).ValueMember =
                "operator_id";
        }
        private void FillComboBox1()
        {
            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                SqlDataAdapter sqlAdapter = new SqlDataAdapter("select * from TaxiDriver", sqlConnection);

                DataSet dataSet = new DataSet();
                sqlAdapter.Fill(dataSet, "car");

                comboBox1.DataSource = dataSet.Tables["car"];
                comboBox1.DisplayMember = "driver_name";
                comboBox1.ValueMember = "driver_id";
            }
        }

        private void Selection_Click(object sender, EventArgs e)
        {
            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Open();
                SqlCommand sqlCommand =
                    new SqlCommand("SELECT n.order_phone, n.order_cost" +
                                  " FROM TaxiDriver p join TaxiTable m on p.driver_id = m.table_driver_id join TaxiOrder n on m.table_id = n.order_table_id" +
                                  " where p.driver_id = " + comboBox1.SelectedValue
                                  , sqlConnection);
                SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
                DataTable dataTable = new DataTable("report1");
                dataTable.Columns.Add("Телефон");
                dataTable.Columns.Add("Цена");
                while (sqlDataReader.Read())
                {
                    DataRow row = dataTable.NewRow();
                    row["Телефон"] = sqlDataReader["order_phone"];
                    row["Цена"] = sqlDataReader["order_cost"];
                    dataTable.Rows.Add(row);
                }

                sqlDataReader.Close();
                dataGridView2.DataSource = dataTable;
            }
        }

        private void Procedure_Click(object sender, EventArgs e)
        {
            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                SqlDataAdapter sqlAdapter = new SqlDataAdapter("order_byMonth", sqlConnection);
                sqlAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                sqlAdapter.SelectCommand.Parameters.Add(new SqlParameter("@month", SqlDbType.Int));
                sqlAdapter.SelectCommand.Parameters["@month"].Value = numericUpDown1.Value;

                sqlAdapter.SelectCommand.Parameters.Add(new SqlParameter("@year", SqlDbType.Int));
                sqlAdapter.SelectCommand.Parameters["@year"].Value = numericUpDown2.Value;

                DataSet dataSet = new DataSet();
                sqlAdapter.Fill(dataSet, "procedure");

                dataGridView3.DataSource = dataSet.Tables["procedure"];
            }
        }
    }
}
