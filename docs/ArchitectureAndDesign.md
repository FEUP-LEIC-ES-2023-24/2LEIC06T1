# Architecture and Design

## Logical architecture

![Logical architecture UML](./Assets/Logical%20architecture.drawio.png)

- **Couch Potato UI** : aplication pages;
- **Couch Potato Business Logic** : manipulation and manegement of User data;
- **FireBase Database Schema** : where some the information of the application is stored;
- **Google Acount** : conects with google services;

## Physical architeture

![Phiysical architeture UML](./Assets/Physical%20architecture.drawio.png)

The Pysical arqchiteture diagram is composed by three nodes, which represent the pysical devices presentin the project.

- The First Node is the Smartphone device, that contains the Couch Potato (Flutter) application component.

- The Second Node is the FireBase Server, that serve as an interface between the Smartphone divice and the Google Server while receiving the user requests and providing the expected services as well, which containd three components:

  1. Couch Potato UI (Dart);
  2. Couch Potato Business Logic (Dart);
  3. Couch Potato Data Base (Firebase Realtime Database);

- The Third Node id the Google Server, were there is information saved about the users Google acount.

## Vertical prototype

![Add Post](./Assets/CREATE%20POST%202.png)
![Delivery Popoup](./Assets/ITEM%20ACQUISITION.png)
![Feed](./Assets/FEED.png)
![Google Autentication](./Assets/Google%20Autentication.png)
![No Conection Page](./Assets/NO%20INTERNET.png)
![Preview Page](./Assets/CREATE%20POST.png)
