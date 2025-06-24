using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace BusinesLayer.PoliMusicV3
{
    public class User
    {
        private string strConnectionString;
        public User(string strConnString)
        {
            strConnectionString = strConnString;
        }
        public int Save(EntityLayer.PoliMusicV3.User user)
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).Save(user);
        }
        public DataTable Read()
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).Read();
        }

        public int Update(EntityLayer.PoliMusicV3.User user)
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).Update(user);
        }

        public int Delete(int id)
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).Delete(id);
        }
        public DataTable AuthenticateUser(string login, string password)
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).AuthenticateUser(login, password);
        }
        public int CheckExistUser(string userName)
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).CheckExistUser(userName);
        }
        public int CheckExistEmail(string email)
        {
            return new DataAccess.PoliMusicV3.User(strConnectionString).CheckExistEmail(email);
        }
        public string ValidationsDuplicated(EntityLayer.PoliMusicV3.User user)
        {
            int returnValue = CheckExistUser(user.UserName);
            if (returnValue != 0)
            {
                return "Username already registered!";
            }
            returnValue = CheckExistEmail(user.Email);
            if (returnValue != 0)
            {
                return "Email already used!.";
            }
            return string.Empty;
        }
    }

}
