﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV3
{
    public partial class Login : System.Web.UI.Page
    {
        string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
#if DEBUG
                txtLogin.Text = "userPlayer";
                //txtLogin.Text = "userAdmin";
                txtPassword.Text = "12345678";
                txtPassword.Attributes.Add("value", txtPassword.Text);
                txtPassword.TextMode = TextBoxMode.Password;
#endif
                lblMessage.Text = string.Empty;
            }
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string login = txtLogin.Text;
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(login) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please, write a login/password.";
                return;
            }
            /*
            if (login != "userAdmin" || password != "12345678")//TODO: Read from database
            {
                lblMessage.Text = "Login/password incorrect, try again";
                return;
            }
            //FormsAuthentication.RedirectFromLoginPage(login, true);
            Response.Redirect("Default.aspx");
            */
            password = EntityLayer.PoliMusicV3.Util.Hash.GeneratePasswordHash(password);
            DataTable dtUser = new BusinesLayer.PoliMusicV3.User(strConnString).AuthenticateUser(login, password);

            if (dtUser != null && dtUser.Rows.Count > 0)
            {
                EntityLayer.PoliMusicV3.User user = new EntityLayer.PoliMusicV3.User();
                user.ID = Convert.ToInt32(dtUser.Rows[0]["ID_USER"]);
                user.UserName = login;
                user.Photo = dtUser.Rows[0]["USER_PHOTO"].ToString();
                user.Email = dtUser.Rows[0]["EMAIL"].ToString();
                user.Birthday = dtUser.Rows[0]["BIRTHDAY"].ToString();
                user.UserType = Convert.ToInt32(dtUser.Rows[0]["USER_TYPE"]);
                if (user.UserType == EntityLayer.PoliMusicV3.Util.Constants.ID_USER_NORMAL)
                {
                    Session[EntityLayer.PoliMusicV3.Util.Constants.USER] = user.UserName;
                    FormsAuthentication.RedirectFromLoginPage(login, true);
                    Response.Redirect("~/Songs.aspx?uid=" + user.ID, true);
                }
                else if (user.UserType == EntityLayer.PoliMusicV3.Util.Constants.ID_USER_ADMIN)
                {
                    Session[EntityLayer.PoliMusicV3.Util.Constants.USER] = user.UserName;
                    FormsAuthentication.RedirectFromLoginPage(login, true);
                    Response.Redirect("~/DesktopAdmin.aspx?uid=" + user.ID, true);
                }
                else
                {
                    lblMessage.Text = "Login/password incorrect, try again.";
                    return;
                }
            }
            else
            {
                lblMessage.Text = "Login/password incorrect, try again.";
                return;
            }
            //#endif
            lblMessage.Text = string.Empty;
        }

        protected void LinkButtonNewUser_Click(object sender, EventArgs e)
        {
            Response.Redirect("SignUp.aspx", true);
        }
    }
}