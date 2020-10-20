using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WebFirst
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            WebClass wc = new WebClass();
            txtInput.Text = wc.Showme();

        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {

            WebClass wc = new WebClass();
            GrdView.DataSource = wc.ConnectME();
            GrdView.DataBind();
        }
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtInput.Text = null;
            
        }
    }
}