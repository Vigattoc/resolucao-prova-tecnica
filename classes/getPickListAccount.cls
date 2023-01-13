public class getPickListAccount {
	@AuraEnabled
    public static List<string> teste() {
        list<string> lista = new list<string>();
        lista.add('santa Cruz');
        System.debug(lista);
        return lista;
    }

}