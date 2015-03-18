using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Config;
using RestSharp;
using System.Net;
using System.ServiceModel.Web;

namespace PmsNCRWcf.Model
{
    public class ApiClient
    {
        private static string token = ApiConfig.Token;

        public T Execute<T>(IRestRequest request) where T : new()
        {
            var response = genClient().Execute<T>(request);
            return response.Data;
        }

        public IRestResponse Execute(IRestRequest request)
        {
            var response = genClient().Execute(request);
            return responseHandler(response);
        }

        private RestClient genClient()
        {
            var client = new RestClient();
            client.BaseUrl = ApiConfig.BaseUri;
            client.Authenticator = new OAuth2AuthorizationRequestHeaderAuthenticator(token, "Bearer");
            return client;
        }

        private IRestResponse responseHandler(IRestResponse res)
        {
            if (res.StatusCode != HttpStatusCode.OK)
            {
                WebOperationContext.Current.OutgoingResponse.StatusCode = res.StatusCode;
                WebOperationContext.Current.OutgoingResponse.StatusDescription = res.StatusDescription;
                throw new WebFaultException<string>(res.StatusDescription, res.StatusCode);
            }
            return res;
        }
    }
}
