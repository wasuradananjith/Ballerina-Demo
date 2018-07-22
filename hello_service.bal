import ballerina/config;
import ballerina/http;
import wso2/twitter;

endpoint twitter:Client twitterEP {
   clientId: config:getAsString("consumerKey"),
   clientSecret: config:getAsString("consumerSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret")
};

endpoint http:Listener listener {
    port: 9090
};

@http:ServiceConfig {
    basePath: "/"
}
service<http:Service> hello bind listener {

    @http:ResourceConfig {
        path: "/"
    }
    sayHello (endpoint caller, http:Request request) {
        string status = check request.getTextPayload();
        twitter:Status st = check twitterEP->tweet(status, "", "");

        http:Response response = new;
        response.setTextPayload("ID:" + <string>st.id + "\n");

        _ = caller->respond(response);
    }
}