/**
 * Simple Apex class to test the GitHub Deploy to Salesforce button.
 * This class has no dependencies and can be deployed to any Salesforce org.
 * 
 * @author Test Deploy
 * @date 2025
 */
public class HelloWorldDeployTest {
    
    /**
     * Returns a greeting message
     * @return String greeting message
     */
    public static String sayHello() {
        return 'Hello from GitHub Deploy!';
    }
    
    /**
     * Returns a greeting with a custom name
     * @param name The name to greet
     * @return String personalized greeting
     */
    public static String sayHelloTo(String name) {
        return 'Hello, ' + name + '! Deployed via GitHub Deploy Tool.';
    }
}

