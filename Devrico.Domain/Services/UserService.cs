using Devrico.Domain.Contracts.Services;
using Experimental.System.Messaging;
using System;
using static Shared.LookUps.LookUps;

namespace Devrico.Domain.Services
{
    public class UserService : IUserService
    {
        string queuePath = @".\private$\queueItem";

        public string PendingRequests()
        {
            try
            {
                using (MessageQueue queueItem = new MessageQueue())
                {
                    queueItem.Path = queuePath;
                    Message myMessage = new Message();
                    myMessage = queueItem.Receive(new TimeSpan(0, 0, 5));
                    myMessage.Formatter = new XmlMessageFormatter(new String[] { "System.String,mscorlib" });
                    string retrievedMessage = myMessage.Body.ToString();
                    return retrievedMessage;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public StatusCode UserSignUp(string message)
        {
            try
            {
                using (MessageQueue queueItem = new MessageQueue())
                {
                    queueItem.Path = queuePath;
                    if (!MessageQueue.Exists(queueItem.Path))
                    {
                        MessageQueue.Create(queueItem.Path);
                    }

                    var myMessage = new Message();
                    myMessage.Body = message;
                    queueItem.Send(myMessage);
                    return StatusCode.Ok;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
