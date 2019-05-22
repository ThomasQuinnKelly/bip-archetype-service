#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.utils;

/**
 * The Class HystrixCommandConstants.
 */
public final class HystrixCommandConstants {

	/** ${artifactName} Service Thread Pool Group. */
	public static final String ${artifactNameUpperCase}_SERVICE_GROUP_KEY = "${artifactName}ServiceGroup";

	/**
	 * Instantiates new hystrix command constants.
	 */
	private HystrixCommandConstants() {

	}
}