import React from 'react';
import { Button, Divider, Grid, Header, Form, Card, Icon, Input } from 'semantic-ui-react';
import MindApp from '../contracts/MindApp.json';

class Flights extends React.Component {
  state = {
    tokenprice: 0,
  };

  componentDidMount = async () => {
    try {
      const { web3 } = this.props;
      const networkId = await web3.eth.net.getId();

      const network = MindApp.networks[networkId];

      const MindApp = new web3.eth.Contract(
        MindApp.abi,
        MindApp.address
      );

      this.setState({ web3, MindApp });
    } catch (error) {
      console.error(error);
    }
  };