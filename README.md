SDK-Samples
===========

GeoLoqal Sample Apps

===========

<h2>Android Sample App</h2>

This sample android app project will get you started quickly using the GeoLoqalAndroid SDK .  

Installation 

1)  This test application can be compiled and run in the standard fashion using Eclipse Android tools. 

2)	First import the test application in your eclipse environment and run the application. If you are facing any problem in  adding the sdk  in the project then you can refer to  http://geoloqal.com/support/documentation/geolocation-android/

3)	Set up the test application by setting the api-key obtained from the developer site. Then set up the speed unit ,output type and speed in the GeoLoqalTestActivity.java as given below

<pre>
  private static String APIKEY = "Set your api-key";
	private static String UNIT = "Set your  speed unit either kph or mph";
	private static String OUTPUTTYPE = "Set your Output type either json or xml";
	private static int SPEED = "Set your speed";
</pre>

4)	Then go to the “res”→ “layout” folder in your Eclipse project  and open the location_service.xml and change the xml tag
<pre>
&lt;com.google.android.maps.MapView 
	android:layout_width="fill_parent"
  android:layout_height="fill_parent"
	android:layout_weight="100"
	android:enabled="true"
	android:clickable="true"
	android:id="@+id/theMap" 
	android:apiKey="Set your api-key" &gt;
</pre>

6)	Then run the application and you will see the below screen.
 
The marker shows the current location in the device and if you are using emulator then follow below steps to simulate your location.

i)	Go to your android/tools directory, and launch the DDMS tool or Go to your DDMS

ii)	 Select the Emulator Control Tab

iii)	 Fill the Location Controls fields with the longitude and latitude values

iv)	 Press the Send button

7)	 When you click on the GeoLocation button, you will get all the test cases for the API key, Choose one of the test cases and press the Start Test button which will make an API request to the Geoloqal API and retrieve the latitude and longitude and displayed on the map.

8)	When you click on the GeoTargeting button it retrieves all the triggers. By selecting one trigger we can check out the trigger matching for a latitude and longitude.


<h2>iOS sample App</h2>

The Sample iPhone app project will get you started quickly using the GeoLoqal iOS SDK. When you open the XCode project, all you need to do is fill in your API key in the application:didFinishLaunchingWithOptions: which you can get from our developer site. 
 
After you build the project, you should see the sample app in the simulator.

 
When you click on the TestCases button, you will get all the test cases for the API key, Choose one of the test cases and press the Start Test button which will make an API request to the Geoloqal API and retrieve the latitude and longitude and displayed on the map.

When you click on the GeoTargeting button it retrieves all the triggers. By selecting one trigger we can check out the trigger matching for a latitude and longitude.

Adding the SDK to an Existing Project

If you are adding the GeoLoqal SDK to an existing iPhone app, follow the steps in documentation guide.

1) Add the library to your project

2) Add –licucore to Other Linker Flags in your build setting.

3) Add the required frameworks to your project.

4) Set up your App Delegate

5) Handle the Events for test cases and triggers




