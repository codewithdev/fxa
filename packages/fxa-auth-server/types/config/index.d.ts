// This interface should be expanded on
// as we slowly move over to TypeScript
interface Config {
  oauthServer: {
    clientIdToServiceNames: Object;
  };
  amplitude: {
    rawEvents: boolean;
    schemaValidation: boolean;
  };
}
