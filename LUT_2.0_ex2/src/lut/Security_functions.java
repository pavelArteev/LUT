package lut;

import java.security.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Security_functions {
	
	static private String[] hexArray = {
			"00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F",
			"10","11","12","13","14","15","16","17","18","19","1A","1B","1C","1D","1E","1F",
			"20","21","22","23","24","25","26","27","28","29","2A","2B","2C","2D","2E","2F",
			"30","31","32","33","34","35","36","37","38","39","3A","3B","3C","3D","3E","3F",
			"40","41","42","43","44","45","46","47","48","49","4A","4B","4C","4D","4E","4F",
			"50","51","52","53","54","55","56","57","58","59","5A","5B","5C","5D","5E","5F",
			"60","61","62","63","64","65","66","67","68","69","6A","6B","6C","6D","6E","6F",
			"70","71","72","73","74","75","76","77","78","79","7A","7B","7C","7D","7E","7F",
			"80","81","82","83","84","85","86","87","88","89","8A","8B","8C","8D","8E","8F",
			"90","91","92","93","94","95","96","97","98","99","9A","9B","9C","9D","9E","9F",
			"A0","A1","A2","A3","A4","A5","A6","A7","A8","A9","AA","AB","AC","AD","AE","AF",
			"B0","B1","B2","B3","B4","B5","B6","B7","B8","B9","BA","BB","BC","BD","BE","BF",
			"C0","C1","C2","C3","C4","C5","C6","C7","C8","C9","CA","CB","CC","CD","CE","CF",
			"D0","D1","D2","D3","D4","D5","D6","D7","D8","D9","DA","DB","DC","DD","DE","DF",
			"E0","E1","E2","E3","E4","E5","E6","E7","E8","E9","EA","EB","EC","ED","EE","EF",
			"F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF"};

	
	
	static private String salt = "1337lut_salt";
	
	static private char[] whitelist = {
		'a','b','c','d','e','f','g','h','i','j','l','m','o','p','q','r','s','t','u','v','w','x','y','z',
		'1','2','3','4','5','6','7','8','9','0',
		'!','\'','§','%','&','/','(',')','=','?',
		'+','*','-','#',
		':','.','~','@',' '
		
	};
	
	
	public synchronized static boolean check_input(Map<String, String[]> input_map){
		Iterator<String> it = input_map.keySet().iterator();
		String[] keys = {};
		boolean flag = false;
		while(it.hasNext()){
			String k = (String) it.next();
			keys = input_map.get(k);
			for(int i=0; i<k.length();i++){
				for(int j=0; j<whitelist.length;j++)
					if(k.charAt(i) == whitelist[j] )
						flag = true;
			if((!flag) && (k.length()>0)) return false;}
			flag = false;
			for(int l=0;l<keys.length;l++){
				String v = keys[l];
				for(int i=0; i<v.length();i++){
					for(int j=0; j<whitelist.length;j++)
						if(v.charAt(i) == whitelist[j] )
							flag = true;
				if((!flag)) return false;
				flag = false;}
			}
			

			
		}
			return	true;
		 
	}
	
	

	
	public static String create_sid(String uname){
		  String prn_hex = "";
	      SecureRandom prng;
		try {
			prng = SecureRandom.getInstance("SHA1PRNG");
			byte[] prn_bytes = new byte[10];
		      prng.nextBytes(prn_bytes);
				for ( byte b : prn_bytes ){
					prn_hex += hexArray[0xFF & b];
				}   
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	      return generate_md5(uname+System.currentTimeMillis()+prn_hex);
	}
	
	
	public static String generate_md5(String s){
        MessageDigest md5; 
        String result ="";
		try {
			md5 = MessageDigest.getInstance("MD5");
			md5.reset();
			md5.update(s.getBytes());
			byte[] digest = md5.digest();
			for ( byte b : digest ){
				result += hexArray[0xFF & b];
			}       
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();    
		}
		return result;
	}
	
	public static String i_can_haz_salty_md5sum(String paswordz){
		/*
		 *   Meow, Paswordz!    / )
		 *                     ( (
		 *       A.-.A  .-""-.  ) )
		 *      / , , \/      \/ /
		 *     =\  t  ;=    /   /
		 *       `--,'  .""|   /
		 *            || |  \\ \
		 *           ((,_|  ((,_\   
		 *  
		 * (Ascii cat by jgs)
		 */
		return generate_md5(paswordz+salt);
	}
	
}
