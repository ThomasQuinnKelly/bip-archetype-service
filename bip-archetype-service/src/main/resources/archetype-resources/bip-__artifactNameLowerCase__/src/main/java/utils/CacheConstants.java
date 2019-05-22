#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.utils;

/**
 * <p>
 * Cache constants and utilities.
 * </p>
 * <p>
 * Note that service impl methods that are cached should use constants declared in this class
 * for their "value" definitions. For example:<br/>
 * {@code @CachePut(value = CacheConstants.CACHE_NAME_STATES, key = "${symbol_pound}root.methodName", unless = ...}
 * </p>
 *
 * @author akulkarni
 */
public class CacheConstants {

	/** Cache name separator */
	private static final String CACHE_NAME_SEPARATOR = "_";

	/** Cache name suffix */
	private static final String CACHE_NAME_SUFFIX =
			CACHE_NAME_SEPARATOR + ApplicationInfo.PROJECT_NAME + CACHE_NAME_SEPARATOR + ApplicationInfo.VERSION;

	/** Cache name for the service */
	public static final String CACHENAME_${artifactNameUpperCase}_SERVICE = "${artifactNameLowerCase}Service" + CACHE_NAME_SUFFIX;

	/** No instantiation */
	private CacheConstants() {
		throw new UnsupportedOperationException("CacheConstants is a static class. Do not instantiate it.");
	}

}