using Devrico.Domain.Contracts.Services;
using Devrico.Domain.Services;
using DevricoApi.Models;
using Experimental.System.Messaging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using static Shared.LookUps.LookUps;

namespace Devrico.UnitTests.DomainUnitTests
{
    [TestClass]
    public class UserServiceTests
    {
        #region Dependencies
        private IUserService _userService { get; set; }
        #endregion


        #region Setups
        [TestInitialize]
        public void TestSetUp()
        {
            _userService = new UserService();
        }
        #endregion

        [TestMethod]
        public void ShouldSignUpUser()
        {
            var user = new User
            {
                Id = 1,
                FirstName = "Manelisi",
                LastName = "Nodada",
                UserName = "Mane",
                Password = "VeryCryptic"
            };

            var serializedUser = JsonConvert.SerializeObject(user, Formatting.Indented);
            var response = _userService.UserSignUp(serializedUser);
            Assert.AreEqual(response, StatusCode.Ok);
        }

        [TestMethod]
        public void ShouldGetPendingRequests()
        {
            var pendingRequest = _userService.PendingRequests();
            Assert.IsNotNull(pendingRequest);
        }

        [ExpectedException(typeof(MessageQueueException))]
        [TestMethod]
        public void ShouldFailWhenNoRequestIsFound()
        {
            _userService.PendingRequests();
        }
    }
}
