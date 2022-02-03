import React from 'react';
import { Button, Container, Grid, Header, Icon, Menu, Segment, Image, Loader } from 'semantic-ui-react';
import MindToken from "./contracts/MindToken.json";
import investment from "./contracts/MindApp.json";

import './App.css';


import getWeb3 from "./getWeb3";

import "./App.css";

class App extends React.Component {
  state = {
    web3: null,
    account: null
  };

  componentDidMount = async () => {
    try {
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      this.setState({ web3, account: accounts[0] });
    } catch (err) {
      console.error(err);
    }
  }


  render() {
    if (!this.state.web3) {
      return <Loader active size="huge" />;
    }
    return (
      <>
        <Segment
          inverted
          textAlign="center"
          style={{
            background: 'url(background.jpeg)',
            backgroundSize: 'cover',
            minHeight: 500,
            padding: '1em 0em'
          }}
          vertical
        >
          <Menu inverted fixed="top" size="large">
            <Container>
              <Menu.Item as="a">
                <Icon name="paper plane outline" /> MindPay
              </Menu.Item>
            </Container>
          </Menu>
          <Container>
            <Header
              as="h1"
              inverted
              style={{
                fontSize: '4em',
                fontWeight: 'normal',
                marginBottom: 0,
                marginTop: '3em'
              }}
            >
              <Icon name="paper plane outline" /> MindPay
            </Header>
            <Header
              as="h2"
              inverted
              style={{
                fontSize: '1.7em',
                fontWeight: 'normal',
                marginTop: '1.5em'
              }}
            >
              Token Locking, Liquidity Fund transfer.
            </Header>
          </Container>
        </Segment>
        <Segment style={{ padding: '4em 0em 8em 0em' }} vertical>
          <Grid container stackable verticalAlign="top">
            <Grid.Row>
              <Grid.Column width={16} textAlign="center">
                <Header as="h4" style={{ color: '#999' }}>
                  Using account {this.state.account}
                </Header>
              </Grid.Column>
            </Grid.Row>
          </Grid>
        </Segment>
        <Segment inverted vertical style={{ padding: '5em 0em' }}>
          <Container style={{ textAlign: 'center' }}>
            <Header as="h4" inverted>
              &copy; 2021
            </Header>
            <p>MindPay</p>
          </Container>
        </Segment>
      </>
    );
  }
}

export default App;
