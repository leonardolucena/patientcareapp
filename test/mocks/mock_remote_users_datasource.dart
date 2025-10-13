import 'package:patientcareapp/data/models/user_model.dart';
import 'package:patientcareapp/data/models/address_model.dart';
import 'package:patientcareapp/data/models/company_model.dart';
import 'package:patientcareapp/data/models/geo_model.dart';

/// Mock do RemoteUsersDatasource para testes
/// Não herda da classe original para evitar dependência do ApiGateway
class MockRemoteUsersDatasource {
  Future<List<UserModel>> getAllUsers() async {
    // Retorna 10 usuários mockados
    return [
      const UserModel(
        id: 1,
        name: 'Leanne Graham',
        username: 'Bret',
        email: 'Sincere@april.biz',
        address: AddressModel(
          street: 'Kulas Light',
          suite: 'Apt. 556',
          city: 'Gwenborough',
          zipcode: '92998-3874',
          geo: GeoModel(lat: '-37.3159', lng: '81.1496'),
        ),
        phone: '1-770-736-8031 x56442',
        website: 'hildegard.org',
        company: CompanyModel(
          name: 'Romaguera-Crona',
          catchPhrase: 'Multi-layered client-server neural-net',
          bs: 'harness real-time e-markets',
        ),
      ),
      const UserModel(
        id: 2,
        name: 'Ervin Howell',
        username: 'Antonette',
        email: 'Shanna@melissa.tv',
        address: AddressModel(
          street: 'Victor Plains',
          suite: 'Suite 879',
          city: 'Wisokyburgh',
          zipcode: '90566-7771',
          geo: GeoModel(lat: '-43.9509', lng: '-34.4618'),
        ),
        phone: '010-692-6593 x09125',
        website: 'anastasia.net',
        company: CompanyModel(
          name: 'Deckow-Crist',
          catchPhrase: 'Proactive didactic contingency',
          bs: 'synergize scalable supply-chains',
        ),
      ),
      const UserModel(
        id: 3,
        name: 'Clementine Bauch',
        username: 'Samantha',
        email: 'Nathan@yesenia.net',
        address: AddressModel(
          street: 'Douglas Extension',
          suite: 'Suite 847',
          city: 'McKenziehaven',
          zipcode: '59590-4157',
          geo: GeoModel(lat: '-68.6102', lng: '-47.0653'),
        ),
        phone: '1-463-123-4447',
        website: 'ramiro.info',
        company: CompanyModel(
          name: 'Romaguera-Jacobson',
          catchPhrase: 'Face to face bifurcated interface',
          bs: 'e-enable strategic applications',
        ),
      ),
      const UserModel(
        id: 4,
        name: 'Patricia Lebsack',
        username: 'Karianne',
        email: 'Julianne.OConner@kory.org',
        address: AddressModel(
          street: 'Hoeger Mall',
          suite: 'Apt. 692',
          city: 'South Elvis',
          zipcode: '53919-4257',
          geo: GeoModel(lat: '29.4572', lng: '-164.2990'),
        ),
        phone: '493-170-9623 x156',
        website: 'kale.biz',
        company: CompanyModel(
          name: 'Robel-Corkery',
          catchPhrase: 'Multi-tiered zero tolerance productivity',
          bs: 'transition cutting-edge web services',
        ),
      ),
      const UserModel(
        id: 5,
        name: 'Chelsey Dietrich',
        username: 'Kamren',
        email: 'Lucio_Hettinger@annie.ca',
        address: AddressModel(
          street: 'Skiles Walks',
          suite: 'Suite 351',
          city: 'Roscoeview',
          zipcode: '33263',
          geo: GeoModel(lat: '-31.8129', lng: '62.5342'),
        ),
        phone: '(254)954-1289',
        website: 'demarco.info',
        company: CompanyModel(
          name: 'Keebler LLC',
          catchPhrase: 'User-centric fault-tolerant solution',
          bs: 'revolutionize end-to-end systems',
        ),
      ),
      const UserModel(
        id: 6,
        name: 'Mrs. Dennis Schulist',
        username: 'Leopoldo_Corkery',
        email: 'Karley_Dach@jasper.info',
        address: AddressModel(
          street: 'Norberto Crossing',
          suite: 'Apt. 950',
          city: 'South Christy',
          zipcode: '23505-1337',
          geo: GeoModel(lat: '-71.4197', lng: '71.7478'),
        ),
        phone: '1-477-935-8478 x6430',
        website: 'ola.org',
        company: CompanyModel(
          name: 'Considine-Lockman',
          catchPhrase: 'Synchronised bottom-line interface',
          bs: 'e-enable innovative applications',
        ),
      ),
      const UserModel(
        id: 7,
        name: 'Kurtis Weissnat',
        username: 'Elwyn.Skiles',
        email: 'Telly.Hoeger@billy.biz',
        address: AddressModel(
          street: 'Rex Trail',
          suite: 'Suite 280',
          city: 'Howemouth',
          zipcode: '58804-1099',
          geo: GeoModel(lat: '24.8918', lng: '21.8984'),
        ),
        phone: '210.067.6132',
        website: 'elvis.io',
        company: CompanyModel(
          name: 'Johns Group',
          catchPhrase: 'Configurable multimedia task-force',
          bs: 'generate enterprise e-tailers',
        ),
      ),
      const UserModel(
        id: 8,
        name: 'Nicholas Runolfsdottir V',
        username: 'Maxime_Nienow',
        email: 'Sherwood@rosamond.me',
        address: AddressModel(
          street: 'Ellsworth Summit',
          suite: 'Suite 729',
          city: 'Aliyaview',
          zipcode: '45169',
          geo: GeoModel(lat: '-14.3990', lng: '-120.7677'),
        ),
        phone: '586.493.6943 x140',
        website: 'jacynthe.com',
        company: CompanyModel(
          name: 'Abernathy Group',
          catchPhrase: 'Implemented secondary concept',
          bs: 'e-enable extensible e-tailers',
        ),
      ),
      const UserModel(
        id: 9,
        name: 'Glenna Reichert',
        username: 'Delphine',
        email: 'Chaim_McDermott@dana.io',
        address: AddressModel(
          street: 'Dayna Park',
          suite: 'Suite 449',
          city: 'Bartholomebury',
          zipcode: '76495-3109',
          geo: GeoModel(lat: '24.6463', lng: '-168.8889'),
        ),
        phone: '(775)976-6794 x41206',
        website: 'conrad.com',
        company: CompanyModel(
          name: 'Yost and Sons',
          catchPhrase: 'Switchable contextually-based project',
          bs: 'aggregate real-time technologies',
        ),
      ),
      const UserModel(
        id: 10,
        name: 'Clementina DuBuque',
        username: 'Moriah.Stanton',
        email: 'Rey.Padberg@karina.biz',
        address: AddressModel(
          street: 'Kattie Turnpike',
          suite: 'Suite 198',
          city: 'Lebsackbury',
          zipcode: '31428-2261',
          geo: GeoModel(lat: '-38.2386', lng: '57.2232'),
        ),
        phone: '024-648-3804',
        website: 'ambrose.net',
        company: CompanyModel(
          name: 'Hoeger LLC',
          catchPhrase: 'Centralized empowering task-force',
          bs: 'target end-to-end models',
        ),
      ),
    ];
  }
}
