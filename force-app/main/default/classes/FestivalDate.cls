public class FestivalDate {
        public static Map<Integer, List<String>> yearDate(Integer year){
		Map<Integer, Map<String, String>> fest = new Map<Integer, Map<String, String>>();
            fest.put(2022, new Map<String, String>{
            'Holi' => 'March 20, 2022',
            'Diwali' => 'November 24, 2022',
            'Dussehra' => 'October 5, 2022'
        });
             fest.put(2023, new Map<String, String>{
            'Holi' => 'March 20, 2023',
            'Diwali' => 'November 24, 2023',
            'Dussehra' => 'October 5, 2023'
        });
             fest.put(2024, new Map<String, String>{
            'Holi' => 'March 20, 2024',
            'Diwali' => 'November 24, 2024',
            'Dussehra' => 'October 5, 2024'
        });
                       
        Map<String, String> map2 = fest.get(year);
        
        List<String> list1 = new List<String>();
        if (map2 != null) {
            for (String festival : map2.keySet()) {
//                list1.add(festival + ': ' + map2.get(festival));
                System.debug(festival + ': ' +map2.get(festival));
            }
        } else {
            list1.add('Data not found ');
        }
        Map<Integer, List<String>> res = new Map<Integer, List<String>>();
        res.put(year, list1);
        
        return res;
    }
}