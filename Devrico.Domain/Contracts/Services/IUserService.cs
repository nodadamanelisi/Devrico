using static Shared.LookUps.LookUps;

namespace Devrico.Domain.Contracts.Services
{
    public interface IUserService
    {
        StatusCode UserSignUp(string message);
        string PendingRequests();
    }
}
